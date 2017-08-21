class User < ApplicationRecord

	validates(:name, presence: true,length:{maximum:50})
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	before_save { self.email = email.downcase}
	validates :email, presence: true,length:{maximum:255},
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
		has_secure_password
end