require 'rails_helper'

feature 'User can mark one of question answers as favorite', %q{
  In order to show to community,
  An answer that help me to solve a problem
  I'd like to be able to mark one of answers
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario "Not author can't mark one of answers", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Favorite'
  end

  scenario 'Author of question mark one of answers', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_css '.octicon-star'

      first(:link, 'Favorite').click

      expect(page).to have_css '.octicon-star'
      expect(page).to have_css '.octicon-star-fill', count: 1
    end
  end
end
