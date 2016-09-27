# frozen_string_literal: true
require_relative '../feature_helper'

feature 'Only answer author is able to remove files from answer', %q(
  In order to make answer better
  As an answer author
  I want to be able to remove files, attached to it
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:attachment) { create(:attachment) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author, attachments: [attachment]) }

  scenario 'Author deletes a file from answer', js: true do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_link 'rails_helper.rb'

    within('#answers_list .attachment') do
      click_on 'Remove file'
    end

    expect(page).not_to have_content 'rails_helper.rb'
  end

  scenario 'Authenticated user tries to delete file from not his own question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'rails_helper.rb'
    expect(page).not_to have_link 'Remove file'
  end

  scenario 'Not authenticated user tries to delete a question' do
    visit question_path(question)
    expect(page).not_to have_link 'Remove file'
  end
end
