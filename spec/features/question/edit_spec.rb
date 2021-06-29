require 'rails_helper'

feature 'Author can edit his question', %q{
  In order to correct mistakes,
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user tries to edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Authenticated User tries to edit other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user-author', js: true do
    before do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit question'
    end
    scenario 'edits his question' do
      fill_in 'Question title', with: 'edited question title'
      fill_in 'Question body', with: 'edited question body'

      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to have_content 'edited question body'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edits his question with errors' do
      fill_in 'Question title', with: ''
      fill_in 'Question body', with: ''

      click_on 'Save'

      expect(page).to have_content "error(s) detected:"
    end
  end
end
