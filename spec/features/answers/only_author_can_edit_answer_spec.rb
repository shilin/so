require_relative '../feature_helper'

feature 'Only author is able to edit answer', %q(
  In order to make my answer better
  As an author
  I want to be able to edit my answers
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author edits his answer', js: true do
    sign_in author
    answer
    visit question_path(question)

    within("#answer_block_#{answer.id}") do
      click_on 'Edit answer'
      sleep 4
      fill_in :answer_body, with: 'edited_answer'
      click_on 'Save'

      expect(page).to have_content('edited_answer')
    end

    expect(page).to have_content('Answer was successfully updated')
  end

  scenario 'Authenticated user tries to edit not his question' do
    sign_in user
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link('Edit')
    end
  end

  scenario 'Not authenticated user tries to edit question' do
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link('Edit')
    end
  end
end
