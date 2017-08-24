module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
	end
	# ログインしているUserがいる場合
	def current_user
		current_user ||= User.find_by(id: session[:user_id])
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
