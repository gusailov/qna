class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :user_id, :created_at, :updated_at, :files

  belongs_to :user
  belongs_to :question

  has_many :comments
  has_many :links

  def files
    object.files.map do |file|
      { name: file.filename.to_s,
        url: rails_blob_path(file, only_path: true) }
    end
  end
end
