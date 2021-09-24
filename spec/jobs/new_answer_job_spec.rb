require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswer') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  before do
    allow(NewAnswer).to receive(:new).and_return(service)
  end

  it 'calls NewAnswer#send_answer' do
    expect(service).to receive(:send_answer).with(answer)
    NewAnswerJob.perform_now(answer)
  end
end
