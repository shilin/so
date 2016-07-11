require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  # let(:user) { create(:user) }

  let(:commentable) { create(:question) }
  let(:comment) { build(:comment) }

  describe 'POST #create for question' do
    # let(:answer) { build(:answer) }
    # let(:commentable) { create(:question) }

    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves to DB a comment that belongs to the proper question' do
          expect do
            post :create,
                 comment: attributes_for(:comment),
                 question_id: commentable.id,
                 format: :js
          end
            .to change(commentable.comments, :count).by(1)
        end

        it 'renders show create view for comment' do
          post(:create,
               comment: attributes_for(:comment),
               question_id: commentable.id,
               format: :js)

          expect(response).to render_template 'create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to DB' do
          expect do
            post :create,
                 comment: attributes_for(:invalid_comment),
                 question_id: commentable,
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
               question_id: commentable,
               format: :js
        end
          .to_not change(Comment, :count)
      end

      it 'redirects to sign in view' do
        post(:create,
             comment: attributes_for(:invalid_comment),
             question_id: commentable.id,
             format: :js)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
