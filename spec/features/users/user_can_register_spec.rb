# frozen_string_literal: true
require 'rails_helper'

feature 'User can register', %q(
  In order to be able to sign in
  As a user
  I want to be able to register
) do
  given(:user) { create(:user) }

  scenario 'Not registered user registers' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end

  scenario 'Not registered user tries to register with not unique email' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(page).to have_content 'Sign up'
  end
end
