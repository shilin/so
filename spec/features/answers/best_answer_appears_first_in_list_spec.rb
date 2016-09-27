# frozen_string_literal: true
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
    # TODO: refactor id extraction from string
    first_block_id = find('#answers_list ul li:first-child')[:id]
    first_block_id.slice!('answer_block_')
    first_answer_in_the_list = Answer.find(first_block_id)

    expect(first_answer_in_the_list).to be_best
  end
end
