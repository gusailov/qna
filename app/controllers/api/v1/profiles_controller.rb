class Api::V1::ProfilesController < Api::V1::BaseController
  load_and_authorize_resource class: "User"

  def me
    render json: current_user
  end

  def index
    @users = User.where.not(id: current_user.id)
    render json: @users, each_serializer: UsersSerializer
  end
end
