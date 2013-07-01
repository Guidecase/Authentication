require_relative 'test_helper'

class AuthenticatesTest < MiniTest::Unit::TestCase
  def test_login_with_nil_credentials
    assert_nil MockModel.login(nil, nil)
  end

  def test_downcase_email
    model = MockModel.new
    assert_nil model.downcase_email
    
    model.email = 'ABC'
    model.downcase_email
    assert_equal 'abc', model.email
  end

  def test_that_generate_login_token_value_set
    model = MockModel.new
    model.generate_login_token!
    refute_empty model.login_token
  end

  def test_that_generate_verification_token_value_set
    model = MockModel.new
    model.generate_verification_token!
    refute_empty model.verification_token
  end  

  def test_that_generate_password_value_set
    model = MockModel.new
    model.generate_password
    refute_empty model.password
  end

  def test_password_match
    model = MockModel.new
    model.password_salt = BCrypt::Engine.generate_salt
    model.password_hash = BCrypt::Engine.hash_secret('test', model.password_salt)

    assert_equal true, model.password_match?('test')
    assert_equal false, model.password_match?('fail')
  end

  def test_encrypt_password
    model = MockModel.new
    model.send(:encrypt_password)
    assert_nil model.password_salt
    assert_nil model.password_hash
    
    model.password = 'test'
    model.encrypt_password
    assert_equal BCrypt::Engine.hash_secret('test', model.password_salt), model.password_hash
  end  

  def test_password_validation
    model = MockModel.new
    model.password_validation
    assert model.errors[:password].include?('required')

    model = MockModel.new :password => 'a'
    model.password_validation
    assert model.errors[:password].include?('too short')

    model = MockModel.new :password => '123456789'
    model.password_validation
    assert model.errors[:password].empty?
  end
end