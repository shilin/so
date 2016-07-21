class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_and_auth_user

  def facebook
    # render json: request.env['omniauth.auth']
  end

  private

  def find_and_auth_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    end
  end
end
