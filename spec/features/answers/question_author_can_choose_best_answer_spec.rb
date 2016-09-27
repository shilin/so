# frozen_string_literal: true
require_relative '../feature_helper'

feature 'Only author can choose the best answer for his question', %q(
  In order to set apart the best answer for me
  As question's author
  I want to be able to choose the best answer
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    within('#answers_list') do
      expect(page).to_not have_content 'Set as best answer'
    end
  end

  scenario 'Authenticated user tries to choose the best answer' do
    sign_in(user)
    visit question_path(question)

    within('#answers_list') do
      expect(page).to_not have_content 'Set as best answer'
    end
  end

  scenario 'Author chooses the best answer', js: true do
    sign_in(author)
    visit question_path(question)

    within('#answers_list') do
      expect(page).to have_content 'Set as best answer'
    end

    first_answer_id = page.find(:xpath, "//*[@id='answers_list']/ul/li[1]")[:id]

    expect(first_answer_id).to_not eq answers.second.id

    within("#answer_block_#{answers.second.id}") do
      click_on 'Set as best answer'
    end
    sleep 1

    first_answer_id_reordered = page.find(:xpath, "//*[@id='answers_list']/ul/li[1]")[:id]

    expect(page).to have_content 'Answer has been successfully set as best'
    expect(first_answer_id_reordered).to eq "answer_block_#{answers.second.id}"
  end
end
