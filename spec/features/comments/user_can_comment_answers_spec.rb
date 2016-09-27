# frozen_string_literal: true
require_relative '../feature_helper'

feature 'User can comment an answer', %q(
  In order to give feedback and clarify an answer
  As an authenticated user
  I want to be able to give comments on an answer
) do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:user) { create(:user) }
  given(:form_id) { "answer_form_#{answer.id}" }

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'creates a comment', driver: :selenium, js: true do
      visit question_path(question)

      within("#answer_block_#{answer.id}") do
        click_on 'Add a comment'
      end

      within("##{form_id}") do
        fill_in 'comment_body', with: 'My good comment for an answer'
        click_on 'Save'
      end
      expect(page).to have_content 'My good comment for an answer'

      expect(page).to have_content 'Comment was successfully created.'
    end

    scenario 'tries to create an invalid comment', driver: :selenium, js: true do
      visit question_path(question)

      within("#answer_block_#{answer.id}") do
        click_on 'Add a comment'
      end

      within("##{form_id}") do
        fill_in 'comment_body', with:  nil
        click_on 'Save'
      end
      expect(page).to have_content 'Comment could not be created.'
    end
  end

  context 'Not authenticated user' do
    scenario 'tries to comment a question' do
      visit question_path(question)
      expect(page).to_not have_content 'Add a comment'
    end
  end
end
