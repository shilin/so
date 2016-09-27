# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create subscription for question' do
    context 'Authenticated user' do
      sign_in_user
      it 'saves to DB a subscription that belongs to the proper question' do
        expect do
          post :create,
               question_id: question.id,
               subscribable: 'questions',
               format: :js
        end
          .to change(question.subscriptions, :count).by(1)

        expect(@user.subscriptions.size).to eq 1
      end

      it 'renders create.js view' do
        post :create,
             question_id: question.id,
             subscribable: 'questions',
             format: :js

        expect(response).to render_template 'create'
      end
    end

    context 'Not authenticated user' do
      it 'does not save a subscription to DB' do
        expect do
          post :create,
               question_id: question.id,
               subscribable: 'questions',
               format: :js
        end
          .to_not change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        post :create,
             question_id: question.id,
             subscribable: 'questions',
             format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'Delete #destroy subscription for question' do
    context 'Author' do
      sign_in_user
      let!(:subscription) { create(:subscription, subscribable_type: 'Question', subscribable_id: question.id, user: @user) }

      it 'deletes his subscription to question from DB' do
        expect do
          delete :destroy,
                 id: subscription.id,
                 question_id: question.id,
                 subscribable: 'questions',
                 format: :js
        end
          .to change(question.subscriptions, :count).by(-1)
      end

      it 'renders destroy.js view' do
        delete :destroy,
               id: subscription.id,
               question_id: question.id,
               subscribable: 'questions',
               format: :js
        expect(response).to render_template 'destroy'
      end
    end

    context 'Not authenticated user' do
      let!(:subscription) { create(:subscription, subscribable_type: 'Question', subscribable_id: question.id, user: create(:user)) }

      it 'does not delete a subscription' do
        expect do
          delete :destroy,
                 id: subscription.id,
                 question_id: question.id,
                 subscribable: 'questions',
                 format: :js
        end
          .to_not change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        delete :destroy,
               id: subscription.id,
               question_id: question.id,
               subscribable: 'questions',
               format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'Authenticated user' do
      let!(:subscription) { create(:subscription, subscribable_type: 'Question', subscribable_id: question.id, user: create(:user)) }
      sign_in_user

      it 'does not delete a subscription' do
        expect do
          delete :destroy,
                 id: subscription.id,
                 question_id: question.id,
                 subscribable: 'questions',
                 format: :js
        end
          .to_not change(Subscription, :count)
      end
      it 'returns forbidden status' do
        delete :destroy,
               id: subscription.id,
               question_id: question.id,
               subscribable: 'questions',
               format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
