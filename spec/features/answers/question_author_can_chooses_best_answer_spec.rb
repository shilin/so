require_relative '../feature_helper'

feature 'Only author can choose the best answer for his question', %q(
  In order to set apart the best answer for me
  As question's author
  I want to be able to choose the best answer
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author)}
  given!(:answers) { create_list(:answer, 3, question: question, user: user)}

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    within("#answers_list") do
      expect(page).to_not have_content 'Set as best answer'
    end
  end

  scenario 'Authenticated user tries to choose the best answer' do
    sign_in(user)
    visit question_path(question)

    within("#answers_list") do
      expect(page).to_not have_content 'Set as best answer'
    end
  end

  scenario 'Author chooses the best answer', js: true do
    sign_in(author)
    visit question_path(question)

    within("#answers_list") do
      expect(page).to have_content 'Set as best answer'
    end

    id_of_the_first_answer_in_list_answer = find(:xpath, '//*[@id="answers_list"]/ul/li[1]')[:id]

    expect(id_of_the_first_answer_in_list_answer).to_not eq answers.second.id

    within("#answer_block_#{answers.second.id}") do
      click_on 'Set as best answer'
    end

    expect(page).to have_content 'Answer has been successfully set as best'

    id_of_the_first_answer_in_reordered_list_answer = find(:xpath, '//*[@id="answers_list"]/ul/li[1]')[:id]
    expect(id_of_the_first_answer_in_reordered_list_answer).to eq "answer_block_#{answers.second.id}"
  end
end
