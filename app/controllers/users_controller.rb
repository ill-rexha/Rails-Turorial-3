class UsersController < ApplicationController
    
    before_action :logged_in_user, only: [:edit, :update]
  
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)

  	if @user.save
      #アカウントを作成できた場合、その際にログイン
      log_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		#ユーザーページにリダイレクトさせる。
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def logged_in_user
      unless logged_in?
        # ログインしてないのに、編集をしようとした場合にログインを促すflashを出す。
       flash[:danger] = "Please log in."
       redirect_to login_url
      end
  end


private


  def user_params
  	params.require(:user).permit( :name, :email, :password, :password_confirmation)
  end

end
