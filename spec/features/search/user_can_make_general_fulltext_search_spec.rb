# frozen_string_literal: true
require_relative '../feature_helper'

feature 'User can search across the resources', %q(
In order to find resources, related to a word
As a user
I want to be able to make fulltext search
) do
  describe 'General fulltext search' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }
    given!(:comment) { create(:comment, commentable: answer) }

    background do
      index
      visit root_path
    end

    it 'searches for match across all resources' do
      select 'all', from: 'search_resource'
      fill_in 'search_what', with: user.email
      click_on 'Search'

      expect(page).to have_content user.email
    end

    it 'searches for user' do
      select 'user', from: 'search_resource'
      fill_in 'search_what', with: user.email
      click_on 'Search'

      expect(page).to have_content user.email
    end

    it 'searches for question' do
      select 'question', from: 'search_resource'
      fill_in 'search_what', with: question.title
      click_on 'Search'

      expect(page).to have_content question.title
    end

    it 'searches for answer' do
      select 'answer', from: 'search_resource'
      fill_in 'search_what', with: answer.body
      click_on 'Search'

      expect(page).to have_content answer.body
    end

    it 'searches for comment' do
      select 'comment', from: 'search_resource'
      fill_in 'search_what', with: comment.body
      click_on 'Search'

      expect(page).to have_content comment.body
    end
  end
end
