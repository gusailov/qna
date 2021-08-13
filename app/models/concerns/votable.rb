module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      votes.sum(:value)
    end

    def up_rating(user)
      change_rating(user, 1)
    end

    def down_rating(user)
      change_rating(user, -1)
    end

    def un_rating(user)
      votes.find_by(user: user).delete if user_voted?(user)
    end

    private

    def change_rating(user, rating)
      if !user_voted?(user) && !user.author_of?(self)
        votes.create(user: user, value: rating)
      end
    end

    def user_voted?(user)
      user.voted?(self)
    end
  end
end
