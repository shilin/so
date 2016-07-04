require 'rails_helper'

shared_examples 'voted' do

  model = controller_class.controller_path.singularize

  context 'author' do
    sign_in_user
    let(:voted) { create(model, user: @user) }

    context 'PATCH #upvote' do
      it 'does not upvote the voted' do
        voted
        expect { patch :upvote, id: voted, format: :json }.not_to change(voted, :rating)
      end

      it 'renders error_json' do
        patch :upvote, id: voted, format: :json
        error_json = assigns(:vote).errors.full_messages.to_json
        expect(response.body).to eq error_json
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context 'authenticated non-author' do
    sign_in_user
    let!(:voted) { create(model, user: user) }
    let(:rating_json) { { rating: voted.rating, message: "#{model.capitalize} has been successfully upvoted" }.to_json }

    context 'PATCH #upvote' do
      it 'upvotes the voted' do
        patch :upvote, id: voted, format: :json
        expect(voted.rating).to eq 1
      end

      it 'renders rating_json with ok status' do
        patch :upvote, id: voted, format: :json
        expect(response.body).to eq rating_json
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'Not authenticated user' do
    let!(:voted) { create(model, user: user) }
    let(:rating_json) { { rating: voted.rating }.to_json }

    context 'PATCH #upvote' do

      it 'does not upvotes the question' do
        voted
        expect { patch :upvote, id: voted, format: :json }.not_to change(voted, :rating)
      end

      it 'return unauthorized http status' do
        patch :upvote, id: voted, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
