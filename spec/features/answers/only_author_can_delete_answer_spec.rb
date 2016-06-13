require_relative '../feature_helper'

feature 'Only author is able to delete answer', %q(
  In order to remove wrong answers
  As an author
  I want to be able to delete answer
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)
    within('#answers_list') do
      expect(page).to_not have_content 'Delete answer'
    end
  end

  scenario 'Authenticated user tries to delete an answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Author deletes an answer' do
    sign_in(author)
    answer
    visit question_path(question)
    within('#answers_list') do
      click_on 'Delete answer'
    end

    expect(page).to have_content 'Answer has been successfully deleted'
    expect(page).not_to have_content answer.body
  end
end
