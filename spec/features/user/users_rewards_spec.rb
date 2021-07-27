require 'rails_helper'

feature 'The user can view the received rewards', %q{
  In order to view received rewards
  As an authenticated user
  I'd like to be able to view my rewards
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:reward) { create(:reward, question: question) }
  given(:rewarded_user) { create(:user, rewards: [reward]) }

  describe 'Authenticated user' do
    scenario 'view his rewards' do
      sign_in(rewarded_user)
      visit rewards_path

      expect(page).to have_content(rewarded_user.rewards.first.title)

      expect(page).to have_content(rewarded_user.rewards.first.question.title)

      expect(page).to have_css "img[src*='image.jpg']"
    end
  end
end
