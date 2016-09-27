# frozen_string_literal: true
require_relative '../feature_helper'

feature 'User can see a question and its answers', %q(
  In order to get info
  As a user
  I want to be able to see a question and its answers
) do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  before { create_list(:answer, 3, question: question, user: user2) }

  scenario 'User visits question view' do
    visit question_path(question)

    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content('MyAnswerBody', count: 3)
  end
end
