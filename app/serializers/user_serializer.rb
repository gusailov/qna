class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :created_at, :updated_at
  has_many :answers
  has_many :questions
end
