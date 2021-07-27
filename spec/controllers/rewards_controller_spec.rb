require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:reward) { create(:reward, question: question) }

    before { login(user) }
    before { user.rewards.push(reward) }
    before { get :index }

    it 'populates an array of all user rewards' do
      expect(assigns(:rewards)).to match_array(user.rewards)
    end

    it { expect(response).to render_template :index }
  end
end
