require 'rails_helper'

feature 'Author can delete links from his answer', %q{
  In order to remove links from my answer,
  As an question's author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Unauthenticated user tries to ask a question', js: true do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "User tries to delete links from other user's answer", js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Delete Link'
    end
  end

  scenario 'Author delete links from his answer', js: true do
    sign_in(author)

    visit question_path(question)

    within '.answers' do
      click_on 'Edit'
      click_on 'remove link'
      click_on 'Save'

      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
