require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:invalid_question) { create(:invalid_question) }
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:attachment) { create(:attachment) }
  let(:questions) { create_list(:question, 2, user_id: user.id, attachments: [attachment]) }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, user: user) }
    before { get :show, id: question.id }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns empty answer to @answer for the question' do
      expect(assigns(:answer)).to be_a_new(Answer)
      expect(assigns(:answer).question_id).to eq question.id
    end

    it 'builds new empty attachment for new empty answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #new' do
    context 'Not authenticated user' do
      before { get :new }
      it 'does not create new question' do
        expect(assigns(:question)).to be_nil
      end

      it 'redirects to sign_in view' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user' do
      sign_in_user
      before { get :new }

      it 'creates new question and assigns it to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'builds new attachment into @attachments collection' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end

      it 'renders new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    context 'Not authenticated user' do
      let(:question) { create(:question, user: user) }

      before { get :edit, id: question }

      it 'does not assign the requested question to @question' do
        expect(assigns(:question)).to be_nil
      end

      it 'redirects to sign in view' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticated user' do
      sign_in_user
      let(:question) { create(:question, user: author) }
      before { get :edit, id: question }

      it 'does not assign the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'redirects to show view' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'Author' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      before { get :edit, id: question }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update' do
    context 'author' do
      sign_in_user
      let(:question) { create(:question, user: @user, attachments: [attachment]) }

      it 'removes attachment from question' do
        expect do
          patch :update, id: question,
                         question: { attachments_attributes: { id: attachment.id, _destroy: true } }, format: :js
        end
          .to change(question.attachments, :count).by(-1)
      end

      context 'with valid attributes' do
        it 'updates question that belongs to current user and saves it into DB' do
          patch :update, id: question, question: { body: 'edited_body', title: 'edited_title' }, format: :js
          question.reload

          expect(question.body).to eq 'edited_body'
          expect(question.title).to eq 'edited_title'
        end

        it 'renders update js view' do
          patch :update, id: question, question: { body: 'edited_body', title: 'edited_title' }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not save question into DB' do
          patch :update, id: question, question: { body: nil, title: 'edited_title' }, format: :js
          question.reload
          expect(question.body).to_not be_nil
          expect(question.title).to_not eq 'edited_title'
        end
        it 'renders update js view' do
          patch :update, id: question,  question: { body: nil, title: 'edited_title' }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Authenticated user not author with valid attributes' do
      sign_in_user
      let(:question) { create(:question, user: author, attachments: [attachment]) }

      it 'does not remove attachment from question' do
        expect do
          patch :update, id: question,
                         question: { attachments_attributes: { id: attachment.id, _destroy: true } }, format: :js
        end.to_not change(question.attachments, :count)
      end

      it 'does not update question' do
        patch :update, id: question, question: { body: 'edited_body', title: 'edited_title' }, format: :js
        question.reload

        expect(question.body).to_not eq 'edited_body'
        expect(question.title).to_not eq 'edited_title'
      end

      it 'renders update js view' do
        patch :update, id: question, question: { body: 'edited_body', title: 'edited_title' }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not authenticated user with valid attributes' do
      let(:question) { create(:question, user: author, attachments: [attachment]) }

      it 'does not remove attachment from question' do
        expect do
          patch :update, id: question,
                         question: { attachments_attributes: { id: attachment.id, _destroy: true } }, format: :js
        end.to_not change(question.attachments, :count)
      end

      it 'does not update question' do
        patch :update, id: question, question: { body: 'edited_body', title: 'edited_title' }, format: :js
        question.reload

        expect(question.body).to_not eq 'edited_body'
        expect(question.title).to_not eq 'edited_title'
      end

      it 'return unauthorized http status' do
        patch :update, id: question, question: { body: 'edited_body', title: 'edited_title' }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      context 'with valid attributes' do
        it 'creates new question that belongs to current user and saves it into DB' do
          expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save question into DB' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end
        it 're-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end

    context 'not authenticated user with valid attributes' do
      it 'does not save question into DB' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
      end
      it 'redirects to sign in view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question, user: author) }

    context 'Not authenticated user' do
      it 'does not delete question from DB' do
        question
        expect { delete :destroy, id: question.id }.to_not change(Question, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticated user' do
      sign_in_user
      it 'does not delete question from DB' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirects to show view' do
        delete :destroy, id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'Author' do
      sign_in_user
      let(:question_of_signed_in_user) { create(:question, user: @user) }
      it 'deletes question from DB' do
        question_of_signed_in_user
        expect { delete :destroy, id: question_of_signed_in_user }.to change(Question, :count).by(-1)
      end

      it 'redirects to show view' do
        delete :destroy, id: question_of_signed_in_user
        expect(response).to redirect_to questions_path
      end
    end
  end
end
