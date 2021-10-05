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

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'You question successfully deleted.'
  end

  scenario 'Not author tries to delete a question' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
