require_relative '../feature_helper'

feature 'User can add files to his question', %q(
  In order to illustrate my question
  As an author
  I want to be able to attach files to my question
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user adds file when asking question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask a new question'

    fill_in 'question_title', with: 'Question title'
    fill_in 'question_body', with:  'Question body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Save'

    expect(page).to have_content 'Your question has been successfully created!'
    expect(page).to have_link 'rails_helper.rb'
  end
end
