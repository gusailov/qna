require 'rails_helper'

feature 'Authenticated user can add comments to question', %q{
  In order to add some clarifications,
  I'd like to be able to add comments to question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'failure', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "User can add comment to question", js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add comment'

    fill_in 'Comment body', with: 'Comment body'

    click_on 'Add'

    expect(page).to have_content 'Comment body'
  end
  describe 'Multiply sessions', js: true do
    scenario "answer's comments appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Add comment'

        fill_in 'Comment body', with: 'Comment body'

        click_on 'Add'

        expect(page).to have_content 'Comment body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment body'
      end
    end
  end
end
