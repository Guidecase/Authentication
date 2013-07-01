module ActionPack
  module Authentication
    extend ActiveSupport::Concern

    def log_in!(auth)
      session[:user_id] = auth._id
    end

    def log_out!
      reset_session
      reset_cookies
    end

    def current_authenticated_id(klass)
      current_authenticated(klass) ? current_authenticated(klass)._id : session_id
    end

    def current_authenticated(klass)
      if @current_authenticated
        @current_authenticated
      elsif @current_authenticated = auth_from_session(klass)
        @current_authenticated
      elsif @current_authenticated = auth_from_remember_cookie(klass)
        log_in! @current_authenticated
        @current_authenticated
      end
    end

    def session_id
      @session_id ||= request.session_options[:id]
    end

    def store_return_to
      session[:return_to] = request.path
    end

    def return_or_redirect_to(url)
      url = session.delete(:return_to) if session[:return_to]
      redirect_to url
    end

    private

      def auth_from_session(klass)
        klass.where(:id => session[:user_id]).first if session[:user_id]
      end

      def auth_from_remember_cookie(klass)
        klass.remember cookies[:login] if cookies[:login]
      end

      def reset_cookies
        cookies.each { |kv| cookies.delete kv.first.to_sym }
      end
  end
end