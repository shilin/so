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

      context 'regular user ' do
        scenario 'upvotes a question' do
          sign_in(user)
          visit question_path(question)

          find('.question a.upvote-question-link').click
          expect(page).to have_content 'Question has been successfully upvoted'
        end

        scenario 'tries to downvote a question'
      end

      context 'question author' do
        scenario 'tries to upvote a question' do
          sign_in(author)
          visit question_path(question)

          expect(page).to_not have_css("a.upvote-question-link")
        end

        scenario 'tries to downvote a question'
      end
    end
end
