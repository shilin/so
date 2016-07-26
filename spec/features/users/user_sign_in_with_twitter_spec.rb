require_relative '../feature_helper'

feature 'User can sign in with twitter account', %q(
  In order to ask questions and give answers
  As a user
  I want to be able to sign in with my twitter account
) do
  given(:registered_user) { create(:user) }
  given(:guest) { build(:user) }
  given(:provider) { 'twitter' }

  before { visit new_user_session_path }

  scenario 'registered user tries to sign in with twitter account' do
    mock_auth_hash(provider, registered_user.email)

    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(page).to have_content 'Log out'
    expect(current_path).to eq root_path
  end

  scenario 'guest tries to sign in with Twitter account' do
    mock_auth_hash(provider, guest.email)

    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(page).to have_content 'Log out'
    expect(current_path).to eq root_path
  end
end
