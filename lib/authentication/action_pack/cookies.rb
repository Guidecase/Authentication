module ActionPack
  module Authentication
    module Cookies
      extend ActiveSupport::Concern

      def set_login_cookie(auth, session_length)
        cookies[:login] = { :value => auth.login_token, :expires => session_length }
      end
    end
  end
end