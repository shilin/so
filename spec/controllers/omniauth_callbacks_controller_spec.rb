require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #facebook' do
    context 'existing user with identity' do
      before do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook',
                                                                      uid: '123456',
                                                                      info: { email: user.email })
        request.env['devise.mapping'] = Devise.mappings[:user] # If using Devise
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      end

      it 'assigns @user to the proper user' do
        get :facebook
        expect(assigns(:user)).to eq user
      end
    end

    context 'guest with no identity' do
      before do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook',
                                                                      uid: '123456',
                                                                      info: { email: 'strange@user.com' })
        request.env['devise.mapping'] = Devise.mappings[:user] # If using Devise
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      end

      it 'saves to DB a comment that belongs to the proper question' do
        get :facebook
        expect(assigns(:user)).to be_a(User)
      end
    end
  end
end
