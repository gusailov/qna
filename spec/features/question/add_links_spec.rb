require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question,
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/gusailov/55855c441b337efd82231cc154635f04' }

  scenario 'Unauthenticated user tries to ask a question', js: true do
    visit questions_path
   
    expect(page).to_not have_link 'Ask question'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path

      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'add link'
    end

    scenario 'adds links when ask question', js: true do
      fill_in 'Link name', with: 'My Gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My Gist', href: gist_url
    end

    scenario 'adds invalid link when ask question', js: true do
      fill_in 'Link name', with: 'My Gist'
      fill_in 'Url', with: 'terddnjk'

      click_on 'Ask'

      expect(page).to have_content 'This is not link'
    end
  end
end
