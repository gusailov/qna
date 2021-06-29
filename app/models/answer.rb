class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def make_favorite!
    transaction do
      question.answers.update_all(favorite: false)
      update!(favorite: true)
    end
  end
end
