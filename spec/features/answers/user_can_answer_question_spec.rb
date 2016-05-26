require 'rails_helper'

feature 'User can answer a question', %q{
  In order to help people
  As a user
  I want to be able to give an answer to a question
} do

  given(:question) { create(:question) }

  scenario 'User creates an answer to a question' do
    visit question_path(question)

    fill_in :answer_body, with: 'MyAnswer'
    click_on 'Create'

    expect(page).to have_content 'Your answer has been submitted!'
    #TODO expect(page).to have_content 'MyAnswer'
    
  end
end
