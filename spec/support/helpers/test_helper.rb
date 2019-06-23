module Helpers
    module Sessions
      # Returns true if a test user is logged in.
      def is_logged_in?
        !session[:user_id].nil?
      end

      # Log in as a particular user.
      def log_in_as(user)
        session[:user_id] = user.id
      end
    end
  end