# frozen_string_literal: true
require_relative '../feature_helper'

feature 'User can unsubscribe from new answer notification for question', %q(
  In order to get get rid of notifications
  As a user
  I want to be able to unsubscribe from question answer notification
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:subscription) { create(:subscription, user: user, subscribable: question) }

  scenario 'Not authenticated user tries to unsubscribe' do
    visit question_path(question)
    expect(page).not_to have_link 'Unsubscribe from new answers notification'
  end

  scenario 'Authenticated user tries to unsubscribe', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Unsubscribe from new answers notification'

    expect(page).to have_content 'Subscription was successfully destroyed'
    expect(page).to have_link 'Subscribe to new answers notification'
  end
end
