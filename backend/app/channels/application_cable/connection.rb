module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      reject_unauthorized_connection unless current_user
      logger.add_tags 'ActionCable', current_user.email
    end

    private

    def find_verified_user
      uid = request.params[:uid] # ここが NULL にならないかチェック
      client = request.params[:client]
      access_token = request.params[:"access-token"]

      logger.debug "🔍 Authorization: uid=#{uid}, client=#{client}, token=#{access_token}"

      user = User.find_by(uid: uid)

      if user && user.valid_token?(access_token, client)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
