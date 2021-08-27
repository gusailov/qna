class ApplicationController < ActionController::Base
  before_action :gon_user, :authenticity_token, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  def authenticity_token
    gon.authenticity_token = form_authenticity_token
  end
end
