require_relative '../feature_helper'

feature 'Author can edit question', %q(
  In order to make question better
  As an author
  I want to be able to edit my question
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author edits his question', js: true do
    sign_in author
    visit question_path(question)

    click_on 'Edit'

    fill_in :question_body, with: 'edited_question'

    within('.edit_question') do
      click_on 'Save'
    end

    within("#question_#{question.id}") do
      expect(page).to have_content('edited_question')
    end

    expect(page).to have_content('Question was successfully updated.')
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
