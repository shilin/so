require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }
  let(:invalid_question) { create(:invalid_question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

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

      it 'renders new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    context 'Authenticated user' do
      sign_in_user
      before { get :edit, id: question}

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'Not authenticated user' do
      before { get :edit, id: question}

      it 'does not assign the requested question to @question' do
        expect(assigns(:question)).to be_nil
      end

      it 'redirects to sign in view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do

    context 'authenticated user' do
      sign_in_user
      context 'with valid attributes' do

        it 'creates new question and saves it into DB' do
          expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
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

end
