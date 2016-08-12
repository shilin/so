require_relative '../feature_helper'

feature 'User can add files to his answer', %q(
  In order to illustrate my answer
  As an author
  I want to be able to attach files to my answer
) do
  given(:q_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: q_author) }

  scenario 'Authenticated user adds file when giving an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within('.new_answer') do
      fill_in 'answer_body', with:  'my own answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      within('#attachments .links') do
        click_on 'add file'
      end

      within('#attachments .nested-fields:nth-child(2)') do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Save'
    end
    expect(page).to have_content 'Answer was successfully created'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
