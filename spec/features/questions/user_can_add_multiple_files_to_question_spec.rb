require_relative '../feature_helper'

feature 'User can add files to his quesiton', %q(
  In order to illustrate my question
  As a user
  I want to be able to attach files to my question
) do
  given(:user) { create(:user) }
  # given(:question) { create(:question, user: author) }

  scenario 'Authenticated user adds files when creating a question', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Ask a new question'

    fill_in 'question_title', with:  'my question title'
    fill_in 'question_body', with:  'my question body'

    within('#attachments .nested-fields:first-child') do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    within('#attachments .links') do
      click_on 'add file'
    end

    within('#attachments .nested-fields:nth-child(2)') do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Save'

    expect(page).to have_content 'Your question has been successfully created!'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end
