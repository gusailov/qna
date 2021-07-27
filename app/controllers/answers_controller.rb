class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy favorite]
  before_action :not_author_answer, only: %i[update destroy]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def favorite
    @answer.make_favorite! if current_user.author_of?(@answer.question)
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

  def not_author_answer
    return if current_user.author_of?(@answer)

    redirect_to question_path(@answer.question_id),
                notice: 'Only author can do something with answer.'
  end
end
