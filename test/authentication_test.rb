require 'ostruct'
require_relative 'test_helper'

class AuthenticationTest < MiniTest::Unit::TestCase
  include ActionPack::Authentication

  attr_accessor :session, :cookies

  def setup
    self.session = {}
    self.cookies = {}
  end

  def test_that_log_in_stroes_user_id_in_session
    auth = MockModel.new

    log_in!(auth)
    assert_equal auth._id, session[:user_id]
  end

  def test_that_logout_clears_session_and_cookies
    self.session = {:test => true}
    self.cookies = {:test => true}

    log_out!
    assert self.session.keys.empty?
    assert self.cookies.keys.empty?
  end

  def test_that_store_return_to_sets_request_path
    store_return_to
    assert_equal request.path, session[:return_to]
  end

  def test_session_id
    assert_equal request.session_options[:id], session_id
  end

  def test_that_return_or_redirect_to_uses_url_param
    url = 'testing/redirection'

    assert_equal url, return_or_redirect_to(url)
  end

  def test_that_return_or_redirect_to_uses_session_redirect_to
    self.session = {:return_to => 'redirect/path'}
    url = 'testing/redirection'

    assert_equal session[:return_to], return_or_redirect_to(url)
    refute session.has_key?(:return_to)
  end  

  def test_that_reset_cookies_clears_cookies
    self.cookies = {:test => true}
    reset_cookies
    assert_equal Hash.new, cookies  
  end

  def test_that_auth_from_session_is_nil
    assert_nil auth_from_session(MockModel)

    session[:user_id] = 'miss'
    assert_nil auth_from_session(MockModel)
  end

  def test_that_auth_from_session_finds_by_session_user_id
    model = MockModel.create! :email => 'test@example.com', :password => 'testing123'
    session[:user_id] = model._id.to_s

    assert_equal model, auth_from_session(MockModel)
  end

  def test_that_auth_from_remember_cookie_is_nil
    assert_nil auth_from_remember_cookie(MockModel)

    cookies[:login] = 'miss'
    assert_nil auth_from_remember_cookie(MockModel)
  end

  def test_that_auth_from_session_finds_by_login_cookie
    model = MockModel.create! :email => 'test@example.com', :password => 'testing123'
    model.generate_login_token!
    self.cookies = {:login => model.login_token}

    assert_equal model, auth_from_remember_cookie(MockModel)
  end

  def test_that_current_authenticated_is_memoized
    model = MockModel.new 
    instance_variable_set('@current_authenticated', model)
    assert_equal model, current_authenticated(MockModel)
  end

  def test_that_current_authenticated_is_loaded_from_session
    model = MockModel.create! :email => 'test@example.com', :password => 'testing123'
    session[:user_id] = model._id.to_s

    assert_equal model, current_authenticated(MockModel)
    assert_equal model, instance_variable_get('@current_authenticated')
  end

  def test_that_current_authenticated_is_loaded_from_cookie
    model = MockModel.create! :email => 'test@example.com', :password => 'testing123'
    model.generate_login_token!
    self.cookies = {:login => model.login_token}

    assert_equal model, current_authenticated(MockModel)
    assert_equal model, instance_variable_get('@current_authenticated')
  end

  def test_current_authenticated_id_from_cached_model
    model = MockModel.new 
    instance_variable_set('@current_authenticated', model)
    assert_equal model._id, current_authenticated_id(MockModel)
  end

  def test_current_authenticated_id_from_session_id
    assert_equal request.session_options[:id], current_authenticated_id(MockModel)
  end

  private

    def reset_session; self.session={}; end

    def redirect_to(url); url; end

    def request
      @request ||= OpenStruct.new(:path => 'test/path', :session_options => { :id => 'test-sid'})
    end  
end