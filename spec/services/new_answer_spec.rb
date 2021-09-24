require 'rails_helper'

RSpec.describe NewAnswer do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:subscription) { create(:subscription, user: user, question: question) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'send notification to all subscribed users' do
    answer.question.subscribers.find_each do |user|
      expect(NewAnswerMailer).to receive(:notify).with(user, answer).and_call_original
      subject.send_answer(answer)
    end
  end
end