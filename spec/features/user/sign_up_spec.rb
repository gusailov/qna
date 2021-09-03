require 'rails_helper'

feature 'User can Sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do
  background { visit new_user_registration_path }

  scenario 'Unregistered user signs up' do
    within '.new_user' do
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'
    end
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  describe 'OAuth authentication' do
    it "can sign in user with GitHub account" do
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from Github account.')
    end

    it "can sign in user with Facebook account" do
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end
  end
end
