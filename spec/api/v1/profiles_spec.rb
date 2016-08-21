require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let!(:other_users) { create_list(:user, 3) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET #index' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { get '/api/v1/profiles/', format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      it 'contains json with the other users' do
        other_users.each do |user|
          expect(response.body).to include_json(user.to_json)
        end
      end
    end

    def make_request(options = {})
      get '/api/v1/profiles/', { format: :json }.merge(options)
    end
  end

  describe 'GET #me' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def make_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end
end
