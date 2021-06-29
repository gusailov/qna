require 'rails_helper'

feature 'User can create answer on question page', %q{
  In order to answer the question,
  As an authenticated user
  I'd like to be able to answer the question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer a question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer the question'

      expect(current_path).to eq question_path(question)
      within('.answers') do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'answer a question with errors' do
      click_on 'Answer the question'

      expect(page).to have_content "error(s) detected:"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Answer the question'
  end
end
