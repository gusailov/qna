require 'rails_helper'

shared_examples_for 'commented' do
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  before do
    login(user)
  end

  describe 'POST #add_comment' do
    it 'saves a new Comment in the database' do
      expect {
        post :add_comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :json
      }.to change(commentable.comments, :count).by(1)
    end

    it 'renders json' do
      post :add_comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :json

      expected = {
        item: commentable.comments.last,
        controller_name: commentable.class.name.downcase
      }.to_json

      expect(response.body).to eq(expected)
    end
  end
end