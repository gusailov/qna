require 'rails_helper'

shared_examples_for 'status 200' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end