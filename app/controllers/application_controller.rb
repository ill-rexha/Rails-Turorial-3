class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

 private

 	def logged_in_user
      unless logged_in?
       # ログインしてないのに、編集をしようとした場合にログインを促すflashを出す。
       store_location
       flash[:danger] = "Please log in."
       redirect_to login_url
      end
    end
end
