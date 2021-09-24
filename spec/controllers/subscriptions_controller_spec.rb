require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe "POST #create" do
    before { login(user) }

    it "creates a new Subscription" do
      expect {
        post :create, params: { question_id: question.id }, format: :js
      }.to change(Subscription, :count).by(1)
    end

    it "redirects to question" do
      post :create, params: { question_id: question.id }
      expect(response).to redirect_to question
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }
    let!(:subscription) { create(:subscription, question: question, user: user) }

    it "destroys the requested subscription" do
      expect {
        delete :destroy, params: { id: subscription.id }
      }.to change(Subscription, :count).by(-1)
    end

    it "redirects to question" do
      delete :destroy, params: { id: subscription.id }
      expect(response).to redirect_to question
    end
  end
end
