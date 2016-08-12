require_relative '../feature_helper'

feature 'Only author is able to delete a question', %q(
  In order to remove bad question
  As an author
  I want to be able to delete question
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author deletes a question' do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Question was successfully destroyed'
    expect(page).not_to have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete not his own question' do
    sign_in(user)

    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
    expect(page).not_to have_button 'Delete question'
  end

  scenario 'Not authenticated user tries to delete a question' do
    visit question_path(question)
    expect(page).not_to have_link 'Delete question'
    expect(page).not_to have_button 'Delete question'
  end
end
