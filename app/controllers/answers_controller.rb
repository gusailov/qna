class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[destroy]
  before_action :not_author_answer, only: :destroy

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question_id), notice: 'You answer successfully deleted.'
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def not_author_answer
    return if current_user.author_of?(@answer)

    redirect_to question_path(@answer.question_id), notice: 'Only author can delete this answer.'
  end
end
