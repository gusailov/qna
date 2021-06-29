require 'rails_helper'

feature 'Any user can view question and its answers', %q{
  To find out the answer to the question asked earlier,
  As an unauthenticated user
  I would like to see the question and the answers to it
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'Unauthenticated user view question and its answers', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content(answer.body, count: 5)
    end
  end
end
