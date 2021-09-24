class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create_commit :broadcast_self, :notify

  def make_favorite!
    transaction do
      question.answers.update_all(favorite: false)
      update!(favorite: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def broadcast_self
    ActionCable.server.broadcast("questions_channel_#{question.id}",
                                 { answer: self,
                                   answer_rating: rating,
                                   answer_files: files_array,
                                   answer_links: links_array,
                                   question: question })
  end

  def files_array
    files.map do |file|
      { id: file.id,
        name: file.filename.to_s,
        url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end
  end

  def links_array
    links.map do |link|
      { id: link.id,
        name: link.name,
        url: link.url,
        gist: link.gist?,
        gist_id: link.gist_id }
    end
  end

  def notify
    NewAnswerJob.perform_later(self)
  end
end
