# frozen_string_literal: true
require_relative '../feature_helper'

feature 'User upvotes and downvotes a question', %q(
  In order to promote good question
  As an authenticated user
  I want to be able to upvote and downvote a question
) do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  context 'authenticated user' do
    context 'non-author' do
      scenario 'upvotes a question' do
        sign_in(user)
        visit question_path(question)

        find('.question a.upvote-question-link').click
        expect(page).to have_content 'Question has been successfully upvoted'
      end

      scenario 'downvotes a question' do
        sign_in(user)
        visit question_path(question)

        find('.question a.downvote-question-link').click
        expect(page).to have_content 'Question has been successfully downvoted'
      end

      scenario 'call off the vote upon question' do
        sign_in(user)
        visit question_path(question)

        find('.question a.unvote-question-link').click
        expect(page).to have_content 'Question has been successfully unvoted'
      end
    end

    context 'question author' do
      scenario 'tries to upvote a question' do
        sign_in(author)
        visit question_path(question)

        expect(page).to_not have_css('a.upvote-question-link')
      end

      scenario 'tries to downvote a question' do
        sign_in(author)
        visit question_path(question)

        expect(page).to_not have_css('a.downvote-question-link')
      end

      scenario 'tries to unvote a question' do
        sign_in(author)
        visit question_path(question)

        expect(page).to_not have_css('a.unvote-question-link')
      end
    end

    context 'guest' do
      scenario 'tries to upvote a question' do
        visit question_path(question)

        expect(page).to_not have_css('a.upvote-question-link')
      end

      scenario 'tries to downvote a question' do
        visit question_path(question)

        expect(page).to_not have_css('a.downvote-question-link')
      end

      scenario 'tries to unvote a question' do
        visit question_path(question)

        expect(page).to_not have_css('a.unvote-question-link')
      end
    end
  end
end
