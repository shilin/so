require 'rails_helper'

feature 'User creates question', %q{
  In order to get an answer
  As a user
  I want to be able to create a question
} do

  given(:question) { build(:question) }
  given(:invalid_question) { build(:invalid_question) }

  scenario 'User creates a question' do
    visit new_question_path
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with:  question.body
    click_on 'Create'

    expect(page).to have_content 'Your question has been successfully created!'
    expect(page).to have_content question.title
  end

  scenario 'User tries to create an invalid question' do

    visit new_question_path
    fill_in 'question_title', with: invalid_question.title
    fill_in 'question_body', with:  invalid_question.body
    click_on 'Create'

    expect(page).to have_content 'Error creating your question!'
  end

end
