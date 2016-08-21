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

      it 'renders unprocessable_entity status' do
        patch :upvote, id: voted.id, format: :json
        up_error_json = { id: voted.id, message: 'Unable to upvote' }.to_json
        expect(response.body).to eq up_error_json
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'PATCH #downvote' do
      it 'does not downvote the voted' do
        voted
        expect { patch :downvote, id: voted, format: :json }.not_to change(voted, :rating)
      end

      it 'renders unprocessable_entity status' do
        patch :downvote, id: voted, format: :json
        down_error_json = { id: voted.id, message: 'Unable to downvote' }.to_json
        expect(response.body).to eq down_error_json
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'PATCH #unvote' do
      it 'does not unvote the voted' do
        voted
        expect { patch :unvote, id: voted, format: :json }.not_to change(voted, :rating)
      end

      it 'renders unprocessable_entity status' do
        patch :unvote, id: voted, format: :json
        un_error_json = { id: voted.id, message: 'Unable to unvote' }.to_json
        expect(response.body).to eq un_error_json
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context 'authenticated non-author' do
    sign_in_user
    let!(:voted) { create(model, user: user) }
    let(:up_rating_json) { { id: voted.id, rating: voted.rating, message: "#{model.capitalize} has been successfully upvoted" }.to_json }
    let(:down_rating_json) { { id: voted.id, rating: voted.rating, message: "#{model.capitalize} has been successfully downvoted" }.to_json }
    let(:un_rating_json) { { id: voted.id, rating: voted.rating, message: "#{model.capitalize} has been successfully unvoted" }.to_json }

    context 'PATCH #upvote' do
      it 'upvotes the voted' do
        patch :upvote, id: voted, format: :json
        expect(voted.rating).to eq(1)
      end

      it 'renders rating_json with ok status' do
        patch :upvote, id: voted, format: :json
        expect(response.body).to eq up_rating_json
        expect(response).to have_http_status :ok
      end
    end

    context 'PATCH #downvote' do
      it 'downvotes the voted' do
        patch :downvote, id: voted, format: :json
        expect(voted.rating).to eq(-1)
      end

      it 'renders rating_json with ok status' do
        patch :downvote, id: voted, format: :json
        expect(response.body).to eq down_rating_json
        expect(response).to have_http_status :ok
      end
    end

    context 'PATCH #unvote' do
      it 'unvotes the voted' do
        patch :unvote, id: voted, format: :json
        expect(voted.rating).to eq(0)
      end

      it 'renders rating_json with ok status' do
        patch :unvote, id: voted, format: :json
        expect(response.body).to eq un_rating_json
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'Not authenticated user' do
    let!(:voted) { create(model, user: user) }

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

    context 'PATCH #downvote' do
      it 'does not downvotes the question' do
        voted
        expect { patch :downvote, id: voted, format: :json }.not_to change(voted, :rating)
      end

      it 'return unauthorized http status' do
        patch :downvote, id: voted, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'PATCH #unvote' do
      it 'does not unvotes the question' do
        voted
        expect { patch :unvote, id: voted, format: :json }.not_to change(voted, :rating)
      end

      it 'return unauthorized http status' do
        patch :unvote, id: voted, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
