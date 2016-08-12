require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #facebook' do
    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'existing user with identity' do
      before do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook',
                                                                      uid: '123456',
                                                                      info: { email: user.email })
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
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      end

      it 'saves to DB a comment that belongs to the proper question' do
        get :facebook
        expect(assigns(:user)).to be_a(User)
      end
    end
  end

  describe 'GET #twitter' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456')
      get :twitter
    end

    it 'stores data in session' do
      expect(session['provider']).to eq 'twitter'
      expect(session['uid']).to eq '123456'
    end

    it 'does not sign in user' do
      should_not be_user_signed_in
    end

    it 'renders template provide_email' do
      expect(response).to render_template :provide_email
    end

    context 'new user' do
      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
    end
  end
end
