require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_db_column(:favorite) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'notify' do
    let (:user) { create (:user) }
    let (:question) { build(:question, user: user) }
    let (:answer) { build(:answer, question: question, user: user) }

    it 'calls NewAnswerJob' do
      expect(NewAnswerJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
