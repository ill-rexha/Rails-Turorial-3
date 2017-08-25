class User < ApplicationRecord
	# 名前が存在していることを確認し、最大文字数を50文字までに制限
	validates(:name, presence: true,length:{maximum:50})
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	# dbに保存する前に、emailを小文字に
	before_save { self.email = email.downcase}
	# emailが存在していることを確認し、最大文字数を255文字までに制限
	validates :email, presence: true,length:{maximum:255},
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }

	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
 	end

 	def User.new_token
 		SecureRandom.urlsafe_base64
 	end

end
