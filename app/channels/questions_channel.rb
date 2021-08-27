class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    if params[:id]
      stream_from "questions_channel_#{params[:id]}"
    else
      stream_from "questions_channel"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
