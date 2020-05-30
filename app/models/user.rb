class User < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	attr_accessor :remember_token

	validates  :name,:email, presence: true
    validates :name, length: {minimum: 2, maximum: 150}
	validates :email, length: {maximum: 250, 
		message: "Max is 255 characters"}
	validates :email, 
	format: { with: VALID_EMAIL_REGEX },
	uniqueness: true 
	has_secure_password
	validates :password, presence: true,
	length: {minimum: 6}, confirmation: true
	
	def self.digest token
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(token,cost: cost)
	end

	def remember
		#mahoatoken
		self.remember_token = SecureRandom.urlsafe_base64
        self.update_attributes remember_digest: User.digest(self.remember_token)
	end
	def forget
		update_attribute :remember_digest, nil
	end
	def authenticate? token
		BCrypt::Password.new(self.remember_digest).is_password? (token)
	end	
end