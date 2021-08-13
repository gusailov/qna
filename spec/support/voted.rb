require 'rails_helper'

shared_examples 'voted' do
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  before do
    login(user)
  end

  describe 'POST #vote_up' do
    it 'saves a new positive vote in the database' do
      expect {
        post :vote_up, params: { id: votable }, format: :json
      }.to change(votable.votes.where(value: 1), :count).by(1)
    end

    it 'renders json' do
      post :vote_up, params: { id: votable }, format: :json

      expected = {
        item: votable,
        item_rating: votable.rating,
        controller_name: votable.class.name.downcase
      }.to_json

      expect(response.body).to eq(expected)
    end
  end

  describe 'POST #vote_down' do
    it 'saves a new negative vote in the database' do
      expect {
        post :vote_down, params: { id: votable }, format: :json
      }.to change(votable.votes.where(value: -1), :count).by(1)
    end

    it 'renders json' do
      post :vote_up, params: { id: votable }, format: :json

      expected = {
        item: votable,
        item_rating: votable.rating,
        controller_name: votable.class.name.downcase
      }.to_json

      expect(response.body).to eq(expected)
    end
  end

  describe 'PATCH #vote_reset' do
    let!(:vote) { create(:vote, user: user, votable: votable) }

    it 'deletes the vote' do
      expect {
        patch :vote_reset, params: { id: votable }, format: :json
      }.to change(votable.votes, :count).by(-1)
    end

    it 'renders json' do
      patch :vote_reset, params: { id: votable }, format: :json

      expected = {
        item: votable,
        item_rating: votable.rating,
        controller_name: votable.class.name.downcase
      }.to_json

      expect(response.body).to eq(expected)
    end
  end
end
