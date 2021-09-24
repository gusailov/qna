require 'rails_helper'

feature 'Authenticated user can subscribe for liked question', %q{
  In order to be notified when new answer created fo this question,
  I'd like to be able to subscribe for question
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'failure', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Unauthenticated user tries to subscribe for question", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end

  scenario "Question's author automaticaly subscribed", js: true do
    sign_in(author)
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribe', js: true do
      click_on 'Subscribe'

      expect(page).to have_content 'You have successfully subscribed.'
      expect(page).to_not have_link 'Subscribe'
    end

    scenario 'unsunscribe', js: true do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_content 'You have successfully unsubscribed.'
      expect(page).to_not have_link 'Unsubscribe'
    end

  end
end
