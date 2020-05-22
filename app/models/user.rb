class User < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
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

end