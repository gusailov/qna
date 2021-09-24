class NewAnswer

  def send_answer(answer)
    answer.question.subscribers.find_each do |user|
      NewAnswerMailer.notify(user, answer).deliver_later
    end
  end
end