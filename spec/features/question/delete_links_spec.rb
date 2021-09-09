require 'rails_helper'

feature 'Author can delete links from his question', %q{
  In order to remove links from my question,
  As an question's author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Unauthenticated user tries to ask a question', js: true do
    visit questions_path
    
    expect(page).to_not have_link 'Ask question'
  end

  scenario "User tries to delete links from other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete Link'
  end

  scenario 'Author delete links from his question', js: true do
    sign_in(author)

    visit question_path(question)

    click_on 'Edit question'
    click_on 'remove link'
    click_on 'Save'

    expect(page).to_not have_link link.name, href: link.url
  end
end
