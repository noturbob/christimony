module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_account

    def connect
      payload = JsonWebToken.decode(request.params[:token])
      self.current_account = (payload && Account.find_by(id: payload[:account_id])) || reject_unauthorized_connection
    end
  end
end
