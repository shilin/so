require 'rails_helper'

feature 'User can see list of question', %q{
  In order to find a question
  As a user
  I want to be able to see list of questions
} do

  background do
    3.times { create(:question) }
  end

  scenario 'User visits questions resource' do
    visit questions_path

    expect(page).to have_content('MyTitle', count: 3)
  end
end
