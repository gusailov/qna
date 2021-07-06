require 'rails_helper'

feature 'User can delete one of answer attached files', %q{
  In order to correct attached files,
  As an author of answer
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario "Not author can't delete one of answer attached files", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end

  scenario 'Author of question delete one of answer attached files', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      click_on 'Edit'
      fill_in 'Your answer', with: 'edited answer'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Save'

      accept_confirm do
        click_on "delete_file"
      end

      expect(page).to_not have_link "rails_helper.rb"
    end
  end
end
