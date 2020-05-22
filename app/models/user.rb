class User < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates  :name,:email, presence: true
	# validates :name, length: {minimum: 2, maximum: 150}
	validates :email, length: {maximum: 250, message: "Max is 255 characters"}
	validates :email, format: { with: VALID_EMAIL_REGEX }
			,uniqueness: true
	has_secure_password
	validate :check_length_name, if: ->{name.present?}
	def check_length_name
		if name.size > 150 
			errors.add :name, "Length maximum is 150"
		end
	end
end
