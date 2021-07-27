class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def make_favorite!
    transaction do
      question.answers.update_all(favorite: false)
      update!(favorite: true)
      question.reward&.update!(user: user)
    end
  end
end
