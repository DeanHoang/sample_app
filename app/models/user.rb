class User < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	attr_accessor :remember_token ,:activation_token, :reset_token
	before_save :downcase_email
	before_create :create_activation_digest
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

	def authenticate? attribute, token
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password? (token)
	end

	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	def activate
		update_attribute :activated, true
		update_attribute :activated_at, Time.zone.now
	end
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end
	
	def User.new_token
    	SecureRandom.urlsafe_base64
  	end


	private
	def downcase_email
		self.email = email.downcase
	end
# Creates and assigns the activation token and digest.
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end