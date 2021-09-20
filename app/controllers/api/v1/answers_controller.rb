class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  load_and_authorize_resource class: "Answer"

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    if @answer.save
      render json: @answer, status: :created, location: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok, location: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy!

    head :no_content
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: %i[id name url _destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
