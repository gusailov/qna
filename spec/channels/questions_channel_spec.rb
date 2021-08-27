require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it "successfully subscribes" do
    subscribe id: 42
    expect(subscription).to be_confirmed
  end
end
