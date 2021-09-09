class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :find_answer, only: %i[update destroy favorite]
  before_action :find_question, only: %i[create]

  respond_to :js

  authorize_resource

  include Voted
  include Commented

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    respond_with @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
    respond_with @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def favorite
    respond_with @answer.make_favorite!
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
