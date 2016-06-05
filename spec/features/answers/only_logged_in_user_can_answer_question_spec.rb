require 'rails_helper'

feature 'User can answer a question', %q{
  In order to help people
  As a user
  I want to be able to give an answer to a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    background { sign_in(user) }
    scenario 'creates an answer to a question' do
      visit question_path(question)

      fill_in :answer_body, with: 'MyAnswer'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer has been submitted!'
      within('#answers_list') do
        expect(page).to have_content 'MyAnswer'
      end
    end

    scenario 'tries to create an invalid answer to a question' do
      visit question_path(question)

      fill_in :answer_body, with: nil
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Unable to submit your answer'
      within('#answers_list') do
        expect(page).to_not have_content 'MyAnswer'
      end
    end
  end

  context 'Not authenticated user' do
    scenario 'tries to give an answer' do
      visit question_path(question)

      expect(page).not_to have_css ('form#new_answer')

    end
  end

end

