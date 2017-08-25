module SessionsHelper
	
	# 渡されたUserでログインする。
	def log_in(user)
		session[:user_id] = user.id
	end
	
	# ユーザーのセッションを永久化する。
	def remember(user)
		user.remember
		cookie.permanent.signed[:user_id] = user.id
		cookie.permanent[remember_token] = user.remember_token
	end

	# 記憶トークンcookieに対応するユーザーを返す
	def current_user
		# ログインしているUserがいる場合
		if(user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
			
		elsif (user_id = cookies.signed[:user_id])
			  user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end

	end

	# ログインしている場合としていない場合
	def logged_in?
		!current_user.nil?
	end

	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

end
