require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes,
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user tries to edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "Authenticated User tries to edit other user's answer", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''

        click_on 'Save'
      end
      expect(page).to have_content "error(s) detected:"
    end

    scenario 'edits his answer with attached files' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'

        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end
  end
end
