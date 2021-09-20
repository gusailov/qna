class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      render json: @question, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy!

    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id title image _destroy])
  end
end
