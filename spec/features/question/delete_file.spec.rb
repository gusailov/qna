require 'rails_helper'

feature 'User can delete one of question attached files', %q{
  In order to correct attached files,
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario "Not author can't delete one of question attached files", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end

  scenario 'Author of question delete one of question attached files', js: true do
    sign_in(author)
    visit question_path(question)

    within '.question' do
      click_on 'Edit question'

      fill_in 'Question title', with: 'edited question title'
      fill_in 'Question body', with: 'edited question body'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Save'

      accept_confirm do
        click_on "delete_file"
      end

      expect(page).to_not have_link "rails_helper.rb"
    end
  end
end
