require 'ostruct'
require_relative 'test_helper'

class CookiesTest < MiniTest::Unit::TestCase
  include ActionPack::Authentication::Cookies

  attr_accessor :cookies

  def test_that_set_login_cookie_saves_token_and_expiration
    self.cookies = {}
    auth = OpenStruct.new(:login_token => '123')
    expires = 999
    set_login_cookie auth, expires

    cookie = {:value => auth.login_token, :expires => expires}
    assert_equal cookie, cookies[:login]
  end
end