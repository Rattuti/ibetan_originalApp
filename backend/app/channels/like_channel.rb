class LikesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_#{params[:message_id]}_likes"
  end

  def unsubscribed
    stop_all_streams
  end
end
