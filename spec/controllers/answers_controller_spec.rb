require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }


  describe 'POST #create' do

  let(:answer) { build(:answer) }

    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves an answer to DB for the right question' do
          expect { post :create,
                   answer: attributes_for(:answer),
                   question_id: question,
                   format: :js
                  }.
                    to change(question.answers, :count).by(1)
        end

        it 'renders show create view for answer' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :js
          expect(response).to render_template 'create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to DB' do
          expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
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

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, question: question, user: author) }

    context 'Not authenticated user' do
      it 'does not delete answer from DB' do
        answer
        expect { delete :destroy, id: answer.id }.to_not change(Answer, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to new_user_session_path
      end

    end


    context 'Authenticated user' do
      sign_in_user
      it 'does not delete answer from DB' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'Author' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      it 'deletes answer from DB' do
        answer
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

  end




end
