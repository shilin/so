require_relative '../feature_helper'

feature 'User can sign in with facebook account', %q(
  In order to ask questions and give answers
  As a user
  I want to be able to sign in with my fb account
) do
  given(:registered_user) { create(:user) }
  given(:guest) { build(:user) }

  before { visit new_user_session_path }

  scenario 'registered user tries to sign in with facebook account' do
    mock_auth_hash(registered_user.email)

    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from facebook account.'
    expect(page).to have_content 'Log out'
    expect(current_path).to eq root_path
  end

  scenario 'guest tries to sign in with facebook account' do
    mock_auth_hash(guest.email)

    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from facebook account.'
    expect(page).to have_content 'Log out'
    expect(current_path).to eq root_path
  end
end
