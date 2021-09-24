class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[destroy]
  before_action :set_question, only: %i[create]

  load_and_authorize_resource

  def create
    @subscription = @question.subscribe(current_user)

    flash[:notice] = 'You have successfully subscribed.'
    redirect_to @question
  end

  def destroy
    question = @subscription.question
    question.unsubscribe(current_user)

    flash[:notice] = 'You have successfully unsubscribed.'
    redirect_to question
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
