class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswer.new.send_answer(answer)
  end
end
