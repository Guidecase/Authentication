require 'ansi/code'
require 'turn'
require 'minitest/autorun'
require_relative '../lib/authentication'

Mongoid.configure do |config|
  config.connect_to 'test-authentication'
end

class MiniTest::Unit::TestCase
  def teardown
    Mongoid.default_session.collections.each do |collection|
      collection.drop unless collection.name =~ /^system\./
    end
  end
end

class MockModel
  include Mongoid::Document
  include ActiveModel::Authenticates

  attr_accessor :email, :password, :password_salt
end