module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down vote_reset]
  end

  def vote_up
    render_json if @votable.up_rating(current_user)
  end

  def vote_down
    render_json if @votable.down_rating(current_user)
  end

  def vote_reset
    render_json if @votable.un_rating(current_user)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json
    render json: { item: @votable, item_rating: @votable.rating,
                   controller_name: controller_name.singularize }
  end
end
