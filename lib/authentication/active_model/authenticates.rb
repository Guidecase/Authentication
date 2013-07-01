module ActiveModel
  module Authenticates
    extend ActiveSupport::Concern

    EMAIL_REGEX = /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

    included do
      field :email, :type => String
      field :password_salt, :type => String
      field :password_hash, :type => String
      field :login_token, :type => String
      field :nonce_token, :type => String
      field :verification_token, :type => String
      field :verified, :type => Boolean, :default => false

      attr_accessor :password, :password_confirmation
      validate :password_validation

      validates_format_of :email, :with => EMAIL_REGEX,  :multiline => true
      validates_uniqueness_of :email
      validates_presence_of :email

      before_create :generate_verification_token!
      before_save :downcase_email
      before_save :encrypt_password
    end

    module ClassMethods  
      def login(email, password, remember=false)
        return unless email && password
        
        auth = where(:email => email.downcase).first
        if auth && auth.password_salt && auth.password_match?(password)
          auth.generate_login_token! if remember && auth.login_token.blank?
          auth
        end
      end

      def remember(login_token)
        where(:login_token => login_token).first
      end
    end

    def password_match?(password_text)
      password_hash == BCrypt::Engine.hash_secret(password_text, password_salt)
    end

    def generate_password
      self.password = PhonemicPassword.generate(10) if @password.blank?
    end

    def encrypt_password
      if password.present? 
        self.password_salt = BCrypt::Engine.generate_salt 
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end

    def generate_login_token!
      self.login_token = SecureRandom.uuid
      save
    end   

    def generate_nonce!
      self.nonce_token = SecureRandom.uuid
      save
    end 

    def generate_verification_token!
      self.verification_token = SecureRandom.hex(16).encode('UTF-8')
    end

    def downcase_email
      self.email = email.downcase unless email.blank?
    end

    def change_password(new_password, old_password)
      if password_match?(old_password)
        self.password = new_password
        encrypt_password
        return save
      elsif old_password.blank?
        msg = I18n.t :password_required, :default => 'requires password confirmation'
        errors.add :password, msg
      else
        msg = I18n.t :does_not_match, :default => 'does not match'
        errors.add :password, msg
      end
      false
    end

    def change_email(email, password)
      if password_match?(password)
        self.email = email
        return save
      elsif password.blank?
        msg = I18n.t :password_required, :default => 'requires password confirmation'
        errors.add :password, msg
      else
        msg = I18n.t :does_not_match, :default => 'does not match'
        errors.add :password, msg
      end
      false
    end    

    def password_validation
      if password_hash.blank? && password.blank?
        msg = I18n.t :required, :default => 'required'
        errors.add :password, msg
      end

      if !password.blank? && password.length < 8
        msg = I18n.t :required, :default => 'too short'
        errors.add :password, msg
      end
    end    
  end
end