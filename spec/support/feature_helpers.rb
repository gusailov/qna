module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    within '.new_user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end
end
