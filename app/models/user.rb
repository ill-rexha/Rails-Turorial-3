class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token
	# 名前が存在していることを確認し、最大文字数を50文字までに制限
	validates(:name, presence: true,length:{maximum:50})
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	# dbに保存する前に、emailを小文字に
	before_save {email.downcase!}
	#ユーザーが作成される前に、
	before_create :create_activation_digest
	# emailが存在していることを確認し、最大文字数を255文字までに制限
	validates :email, presence: true,length:{maximum:255},
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
	has_secure_password
	# nilのパスワードを有効にする
	# has_secure_passwordによって、生成時に生成時にチェックが入っているので、大丈夫
	validates :password, presence: true, length: { minimum: 6 },allow_nil:true
	# ユーザーがマイクロソフトを複数所有する。
	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
    has_many :following, through: :active_relationships, source: :followed

	# 渡された文字列のハッシュ値を返す
	def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
 	end

 	# ランダムなトークンを返す。
 	def self.new_token
 		SecureRandom.urlsafe_base64
 	end

 	# 永続セッションのためにユーザーをデータベースに記憶する
 	def remember
 		self.remember_token = User.new_token
 		update_attribute(:remember_digest,User.digest(remember_token))
 	end

	# ユーザーのログイン情報を破棄する
	def forget
	  update_attribute(:remember_digest, nil)
	end

	 	# トークンがダイジェストと一致したらtrueを返す
	def authenticated?(attribute, token)
	  digest = send("#{attribute}_digest")
	  return false if digest.nil?
	  BCrypt::Password.new(digest).is_password?(token)
	end

	def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  	end

  # 有効化用のメールを送信する
	def send_activation_email
	  UserMailer.account_activation(self).deliver_now
	end

	 # パスワード再設定の属性を設定する
	def create_reset_digest
	  self.reset_token = User.new_token
	  update_columns(reset_digest: User.digest(reset_token),reset_sent_at: Time.zone.now)
	end

	  # パスワード再設定のメールを送信する
	def send_password_reset_email
	  UserMailer.password_reset(self).deliver_now
	end

	# passoword_resetの有効期限をメール送信後2時間にする。
	def password_reset_expired?
		reset_sent_at< 2.hours.ago
	end

	def feed
		Micropost.where("user_id = ?", id)
	end

	 #  code for user-following
    #========================================================================================================================================
	def follow(other_user)
    	active_relationships.create(followed_id: other_user.id)
	end

	# ユーザーをフォロー解除する
	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	# 現在のユーザーがフォローしてたらtrueを返す
	def following?(other_user)
	    following.include?(other_user)
	end

	private

		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end

end
