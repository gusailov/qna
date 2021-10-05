require 'rails_helper'

feature 'Author can edit his question', %q{
  In order to correct mistakes,
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:gist_url) { 'https://gist.github.com/gusailov/55855c441b337efd82231cc154635f04' }

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
      within '.question' do
        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'

        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      fill_in 'Question title', with: ''
      fill_in 'Question body', with: ''

      click_on 'Save'

      expect(page).to have_content "error(s) detected:"
    end

    scenario 'edits his question with attached files' do
      within '.question' do
        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'

        attach_file 'File',
                    ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario 'edits his question and add links' do
      within '.question' do
        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question title'

        click_on 'add link'

        fill_in 'Link name', with: 'My Gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link 'My Gist', href: gist_url
      end
    end
  end
end
