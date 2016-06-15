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
        expect { delete :destroy, id: answer.id, format: :js }.to_not change(Answer, :count)
      end

      it 'return unauthorized http status' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'Authenticated user' do
      sign_in_user
      it 'does not delete answer from DB' do
        answer
        expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy js view' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      it 'deletes answer from DB' do
        answer
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'return ok http status' do
        delete :destroy, id: answer, format: :js
        expect(response).to have_http_status(:ok)
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

    context 'authenticated user with valid attributes' do
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

    context 'Not authenticated user with valid attributes' do
      let(:answer) { create(:answer, question: question, user: author) }

      it 'does not update answer' do
        patch :update, id: answer, answer: { body: 'edited_answer' }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'edited_answer'
      end

      it 'return unauthorized http status' do
        patch :update, id: answer, answer: { body: 'edited_answer' }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #set_best' do
    context 'author' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      let(:answer) { create(:answer, question: question, user: user) }
      context 'with valid attributes' do
        it 'set answer as best for question that belongs to current user and saves it into DB' do
          patch :set_best, id: answer, answer: { best: true }, format: :js
          answer.reload

          expect(answer.best?).to be true
        end

        it 'renders set_best js view' do
          patch :set_best, id: answer, answer: { best: true }, format: :js
          expect(response).to render_template :set_best
        end
      end
    end

    context 'authenticated user' do
      sign_in_user
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question, user: author) }

      it 'does not set answer as best' do
        patch :set_best, id: answer, answer: { best: true }, format: :js
        answer.reload

        expect(answer.best?).to be false
      end

      it 'renders set_best js view' do
        patch :set_best, id: answer, answer: { best: true }, format: :js
        expect(response).to render_template :set_best
      end
    end

    context 'Not authenticated user' do
      let(:answer) { create(:answer, question: question, user: author) }

      it 'does not set answer as best' do
        patch :set_best, id: answer, answer: { best: true }, format: :js
        answer.reload

        expect(answer.best?).to be false
      end

      it 'return unauthorized http status' do
        patch :set_best, id: answer, answer: { best: true }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
