require_relative '../feature_helper'

feature 'User can see list of question', %q(
  In order to find a question
  As a user
  I want to be able to see list of questions
) do
  given(:user) { create(:user) }

  background { create_list(:question, 3, user: user) }

  scenario 'User visits questions resource' do
    visit questions_path

    expect(page).to have_content('MyQuestionTitle', count: 3)
  end
end
