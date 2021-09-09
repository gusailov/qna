class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :update, :destroy, to: :modify
    alias_action :vote_up, :vote_down, :vote_reset, to: :vote

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]

    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer] do |resource|
      user.author_of?(resource)
    end

    can :add_comment, [Question, Answer]
    cannot :add_comment, [Question, Answer] do |resource|
      user.author_of?(resource)
    end

    can :modify, [Question, Answer] do |resource|
      user.author_of?(resource)
    end

    can :favorite, Answer do |answer|
      user.author_of?(answer.question)
    end

    cannot :favorite, Answer do |answer|
      user.author_of?(answer)
    end

    can :create, Reward do |reward|
      user.author_of?(reward.question)
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end
end
