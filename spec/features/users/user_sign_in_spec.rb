require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions and give answers
  As a user
  I want to be able to sign in
} do
  
  given(:user) { create(:user) }

  scenario 'Registered user signs in' do
    sign_in(user)

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end

  scenario 'Not registered user tries to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: 'WrongPassword'
    click_on 'Log in'

    expect(page).to have_content "Invalid Email or password"
  end
end
