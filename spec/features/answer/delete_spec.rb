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

  scenario 'Not author tries to delete a answer', js: true do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Author tries to delete his a answer', js: true do
    sign_in(author)

    visit question_path(question)

    accept_confirm do
      first(:link, 'Delete answer').click
    end

    expect(page).to_not have_content answer.body
  end
end
