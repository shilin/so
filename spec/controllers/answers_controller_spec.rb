require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves an answer to DB for the right question' do
          expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
        end

        it 'renders show view for question' do
          post :create, answer: attributes_for(:answer), question_id: question
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to DB' do
          expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
        end

        it 're-renders new answer view' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question
          expect(response).to render_template :new
        end

      end
    end

    context 'Not authenticated user' do
        it 'does not save an answer to DB' do
          expect { post :create, answer: attributes_for(:answer), question_id: question }.not_to change(Answer, :count)
        end

        it 'redirects to sign in view' do
          post :create, answer: attributes_for(:answer), question_id: question
          expect(response).to redirect_to new_user_session_path
        end
    end
  end
end
