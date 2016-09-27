# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  # let(:user) { create(:user) }

  let(:comment) { build(:comment) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create for question' do
    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves to DB a comment that belongs to the proper question' do
          expect do
            post :create,
                 comment: attributes_for(:comment),
                 question_id: question.id,
                 commentable: 'questions',
                 format: :js
          end
            .to change(question.comments, :count).by(1)
        end

        it 'renders show create view for comment' do
          post(:create,
               comment: attributes_for(:comment),
               question_id: question.id,
               commentable: 'questions',
               format: :js)

          expect(response).to render_template 'create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to DB' do
          expect do
            post :create,
                 comment: attributes_for(:invalid_comment),
                 question_id: question,
                 commentable: 'questions',
                 format: :js
          end
            .to_not change(Comment, :count)
        end
      end
    end

    context 'Not authenticated user' do
      it 'does not save an answer to DB' do
        expect do
          post :create,
               comment: attributes_for(:invalid_comment),
               question_id: question,
               commentable: 'questions',
               format: :js
        end
          .to_not change(Comment, :count)
      end

      it 'return unauthorized status' do
        post(:create,
             comment: attributes_for(:invalid_comment),
             question_id: question.id,
             commentable: 'questions',
             format: :js)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create for an answer' do
    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves to DB a comment that belongs to the proper answer' do
          expect do
            post :create,
                 comment: attributes_for(:comment),
                 answer_id: answer.id,
                 commentable: 'answers',
                 format: :js
          end
            .to change(answer.comments, :count).by(1)
        end

        it 'renders show create view for comment' do
          post(:create,
               comment: attributes_for(:comment),
               answer_id: answer.id,
               commentable: 'answers',
               format: :js)

          expect(response).to render_template 'create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to DB' do
          expect do
            post :create,
                 comment: attributes_for(:invalid_comment),
                 answer_id: answer,
                 commentable: 'answers',
                 format: :js
          end
            .to_not change(Comment, :count)
        end
      end
    end

    context 'Not authenticated user' do
      it 'does not save an answer to DB' do
        expect do
          post :create,
               comment: attributes_for(:invalid_comment),
               answer_id: answer,
               commentable: 'answers',
               format: :js
        end
          .to_not change(Comment, :count)
      end

      it 'return unauthorized status' do
        post(:create,
             comment: attributes_for(:invalid_comment),
             answer_id: answer.id,
             commentable: 'answers',
             format: :js)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
