module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.email
    end

    private

    def find_verified_user
      uid = request.params[:uid]
      client = request.params[:client]
      token = request.params[:token]

      return reject_unauthorized_connection if uid.blank? || client.blank? || token.blank?

      user = User.find_by(uid: uid)

      if user && user.valid_token?(token, client)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
