module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[add_comment]

    after_action :publish_comment, only: %i[add_comment]
  end

  def add_comment
    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      render json: { item: @comment, controller_name: controller_name.singularize }
    else
      render json: { item: @comment, errors: @comment.errors.full_messages,
                     controller_name: controller_name.singularize }, status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_channel", @comment)
  end
end
