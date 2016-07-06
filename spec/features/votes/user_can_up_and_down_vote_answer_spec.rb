require_relative '../feature_helper'

feature 'User upvotes, unvotes and downvotes an answer', %q(
  In order to promote good answer
  As an authenticated user
  I want to be able to upvote, unvote and downvote a answer
) do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: author) }

  context 'authenticated user' do
    context 'non-author' do
      scenario 'upvotes a answer' do
        sign_in(user)
        visit question_path(question)

        find("#answer_block_#{answer.id} a.upvote-answer-link").click
        expect(page).to have_content 'Answer has been successfully upvoted'
      end

      scenario 'downvotes a answer' do
        sign_in(user)
        answer
        visit question_path(question)

        find("#answer_block_#{answer.id} a.downvote-answer-link").click
        expect(page).to have_content 'Answer has been successfully downvoted'
      end

      scenario 'call off the vote upon answer' do
        sign_in(user)
        visit question_path(question)

        find("#answer_block_#{answer.id} a.unvote-answer-link").click
        expect(page).to have_content 'Answer has been successfully unvoted'
      end
    end

    context 'answer author' do
      scenario 'tries to upvote an answer' do
        sign_in(author)
        visit question_path(question)

        expect(page).to_not have_css('a.upvote-answer-link')
      end

      scenario 'tries to downvote an answer' do
        sign_in(author)
        visit question_path(question)

        expect(page).to_not have_css('a.downvote-answer-link')
      end

      scenario 'tries to unvote an answer' do
        sign_in(author)
        visit question_path(question)

        expect(page).to_not have_css('a.unvote-answer-link')
      end
    end

    context 'guest' do
      scenario 'tries to upvote an answer' do
        visit question_path(question)

        expect(page).to_not have_css('a.upvote-answer-link')
      end

      scenario 'tries to downvote an answer' do
        visit question_path(question)

        expect(page).to_not have_css('a.downvote-answer-link')
      end

      scenario 'tries to unvote an answer' do
        visit question_path(question)

        expect(page).to_not have_css('a.unvote-answer-link')
      end
    end
  end
end
