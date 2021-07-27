require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question,
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/gusailov/55855c441b337efd82231cc154635f04' }

  scenario 'Unauthenticated user tries to ask a answer', js: true do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User adds links when ask answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer the question'

    within('.answers') do
      expect(page).to have_link 'My Gist', href: gist_url
    end
  end
end
