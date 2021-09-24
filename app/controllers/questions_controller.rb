class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]
  after_action :publish_question, only: %i[create]

  respond_to :js

  load_and_authorize_resource

  skip_authorization_check only: %i[index]

  include Voted
  include Commented

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @answer = @question.answers.build
    @subscription = @question.subscription_of(current_user)
    gon.question_id = @question.id
    respond_with @question
  end

  def new
    @question = Question.new
    respond_with @question
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id title image _destroy])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel',
                                 ApplicationController.render(partial: 'questions/question',
                                                              locals: { question: @question }))
  end
end
