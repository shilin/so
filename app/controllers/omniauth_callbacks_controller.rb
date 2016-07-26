class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_and_auth_user

  def twitter; end

  def facebook; end

  private

  def find_and_auth_user
    auth = request.env['omniauth.auth'] || auth_from_previous
    @user = User.find_for_oauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.to_s.camelize) if is_navigational_format?
    else
      session[:provider] = auth.provider
      session[:uid] = auth.uid

      render 'omniauth_callbacks/provide_email'
    end
  end

  def auth_from_previous
    OmniAuth::AuthHash.new(provider: session[:provider], uid: session[:uid], info: { email: params[:email] })
  end
end
