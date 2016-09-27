# frozen_string_literal: true
require_relative '../feature_helper'

feature 'User can subscribe for new answer notification for question', %q(
  In order to get answers immediately
  As a user
  I want to be able to subscribe for question answer notification
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Not authenticated user tries to subscribe' do
    visit question_path(question)
    expect(page).not_to have_link 'Subscribe to new answers notification'
  end

  scenario 'Authenticated user tries to subscribe', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Subscribe to new answers notification'

    expect(page).to have_content 'Subscription was successfully created'
    expect(page).to have_link 'Unsubscribe from new answers notification'
  end

  #  scenario 'Author can resubscribe', js: true do
  #    sign_in(author)
  #
  #    visit question_path(question)
  #    click_on 'Unsubscribe to new answers notification'
  #    expect(page).to have_content 'Subscription was successfully destroyed'
  #
  #    click_on 'Subscribe to new answers notification'
  #
  #    expect(page).to have_content 'Subscription was successfully created'
  #  end
end
