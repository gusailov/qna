require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for users' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    let(:others_question) { create(:question, user: other) }
    let(:others_answer) { create(:answer, question: question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :vote, others_question, user: user }
    it { should_not be_able_to :vote, question, user: user }

    it { should be_able_to :vote, others_answer, user: user }
    it { should_not be_able_to :vote, answer, user: user }

    it { should be_able_to :add_comment, others_question, user: user }
    it { should_not be_able_to :add_comment, question, user: user }

    it { should be_able_to :add_comment, others_answer, user: user }
    it { should_not be_able_to :add_comment, answer, user: user }

    it { should be_able_to :modify, question, user: user }
    it { should_not be_able_to :modify, others_question, user: user }

    it { should be_able_to :modify, answer, user: user }
    it { should_not be_able_to :modify, others_answer, user: other }

    it { should be_able_to :favorite, others_answer }
    it { should_not be_able_to :favorite, answer }

    it { should be_able_to :create, Reward, question: { user_id: user.id } }
  end
end
