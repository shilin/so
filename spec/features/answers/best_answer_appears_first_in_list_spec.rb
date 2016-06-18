require_relative '../feature_helper'

feature 'Answer, chosen by question author appears first in list', %q(
  In order to see the chosen answer
  As a user
  I want to see the answer on top
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, user: user, question: question) }

  scenario 'Unauthenticated user visits question show view' do
    answers.second.update!(best: true)

    visit question_path(question)
    answer_block_id_of_the_first_answer_in_answers_list = find(:xpath, '//*[@id="answers_list"]/ul/li[1]')[:id]
    answer_block_id_of_the_first_answer_in_answers_list.slice!('answer_block_')
    first_answer_in_the_list = Answer.find(answer_block_id_of_the_first_answer_in_answers_list)

    expect(first_answer_in_the_list).to be_best
  end
end
