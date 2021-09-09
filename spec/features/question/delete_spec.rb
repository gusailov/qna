require 'rails_helper'

feature 'Author can delete his question', %q{
  For some reason,
  As an author of question
  I want to remove any of them
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create_list(:question, 5, user: author) }

  scenario 'Author tries to delete his a question' do
    sign_in(author)

    visit questions_path

    first(:link, 'Delete question').click

    expect(page).to have_content 'You question successfully deleted.'
  end

  scenario 'Not author tries to delete a question' do
    sign_in(user)

    visit questions_path

    first(:link, 'Delete question').click

    expect(page).to have_content 'You are not authorized to access this page.'
  end
end
