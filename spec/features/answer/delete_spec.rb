require 'rails_helper'

feature 'Author can delete his answer', %q{
  For some reason,
  As an author answer
  I want to remove any of them
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author tries to delete his a answer' do
    sign_in(author)

    visit question_path(question)

    first(:link, 'Delete answer').click

    expect(page).to have_content 'You answer successfully deleted.'
  end

  scenario 'Not author tries to delete a answer' do
    sign_in(user)

    visit question_path(question)

    first(:link, 'Delete answer').click

    expect(page).to have_content 'Only author can delete this answer.'
  end
end
