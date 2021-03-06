class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_callback('Github')
  end

  def facebook
    oauth_callback('Facebook')
  end

  private

  def oauth_callback(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
