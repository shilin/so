# frozen_string_literal: true
require 'rails_helper'

feature 'User can sign out', %q(
  In order to be safe
  As a signed in user
  I want to be able to sign out
) do
  given(:user) { create(:user) }

  scenario 'Signed-in user signs out' do
    sign_in(user)
    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
    expect(page).not_to have_content 'Log out'
  end

  scenario 'Not signed-in user tries to sign out' do
    visit root_path

    expect(page).not_to have_content 'Log out'
  end
end
