class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[github facebook]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribes, through: :subscriptions, source: :question

  def voted?(resource)
    votes.exists?(votable: resource)
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def subscribed?(question)
    subscribes.exists?(question&.id)
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
