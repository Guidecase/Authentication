$:.push File.expand_path("../lib", __FILE__)

require "authentication/version"

Gem::Specification.new do |spec|
  spec.name         = "authentication"
  spec.version      = Authentication::VERSION
  spec.platform     = Gem::Platform::RUBY  
  spec.summary      = "Earlydoc authentication/authorization"
  spec.description  = "This gem provides active model helpers and Mongoid integration for authenticating users."
  spec.author       = 'Earlydoc'
  spec.email        = 'developer@earlydoc.com'
  spec.homepage     = 'https://www.earlydoc.com'  
  spec.require_path = 'lib'
  spec.required_rubygems_version = ">= 1.8.x"

  spec.files        = `git ls-files`.split("\n")
  spec.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'railties', '~> 4.0.0'

  spec.add_dependency 'mongoid', "~> 4.0"
  spec.add_dependency 'bcrypt-ruby'
end