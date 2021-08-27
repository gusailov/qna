require 'rails_helper'

feature 'Authenticated user can vote for liked answer', %q{
  In order to show to community,
  A question which is better than others
  I'd like to be able to vote for answer
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'failure', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Author can't vote for his question", js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Positive'
      expect(page).to_not have_link 'Negative'
    end
  end

  describe 'Not author of question vote for question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Positive', js: true do
      within '.answers' do
        click_on 'Positive'

        expect(page).to have_content "answer rate:1"
      end
    end

    scenario 'Negative', js: true do
      within '.answers' do
        click_on 'Negative'

        expect(page).to have_content "answer rate:-1"
      end
    end

    scenario 'two times a row', js: true do
      within '.answers' do
        click_on 'Positive'
        expect(page).to have_content "answer rate:1"

        expect(page).to_not have_link 'Positive'
      end
    end

    scenario 'after reset previous vote', js: true do
      within '.answers' do
        click_on 'Positive'
        click_on 'Reset Vote'
        click_on 'Negative'

        expect(page).to have_content "answer rate:-1"
      end
    end
  end
end
