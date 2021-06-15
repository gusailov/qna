require 'rails_helper'

feature 'Any user can view a list of questions', %q{
  To find the answer of interest,
  As an unauthenticated user
  I would like to view the list of questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Any user can view a list of questions' do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
