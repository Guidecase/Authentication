require "bcrypt"
require "mongoid"

module Authentication
end

require_relative "authentication/version"
require_relative "authentication/phonemic_password"
require_relative "authentication/active_model/authenticates"
require_relative "authentication/action_pack/authentication"
require_relative "authentication/action_pack/cookies"