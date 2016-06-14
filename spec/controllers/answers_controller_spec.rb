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
          expect do
            post :create,
                 answer: attributes_for(:answer),
                 question_id: question,
                 format: :js
          end
            .to change(question.answers, :count).by(1)
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

  describe 'PATCH #update' do
    context 'author' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      context 'with valid attributes' do
        it 'updates answer that belongs to current user and saves it into DB' do
          patch :update, id: answer, answer: { body: 'edited_answer' }, format: :js
          answer.reload

          expect(answer.body).to eq 'edited_answer'
        end

        it 'renders update js view' do
          patch :update, id: answer, answer: { body: 'edited_answer' }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer into DB' do
          patch :update, id: answer, answer: { body: nil }, format: :js
          answer.reload
          expect(answer.body).to_not be_nil
        end
        it 'renders update js view' do
          patch :update, id: answer, answer: { body: nil }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not authenticated user with valid attributes' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: author) }

      it 'does not update answer' do
        patch :update, id: answer, answer: { body: 'edited_answer' }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'edited_answer'
      end

      it 'renders update js view' do
        patch :update, id: answer, answer: { body: 'edited_answer' }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
