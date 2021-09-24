class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create { subscribe(user) }

  scope :daily, -> { where(created_at: 1.day.ago.midnight..Time.now.midnight) }

  def subscribe(user)
    subscriptions.create(user: user)
  end

  def unsubscribe(user)
    subscriptions.find_by(user: user).destroy
  end

  def subscription_of(user)
    subscriptions.find_by(user_id: user&.id)
  end
end
