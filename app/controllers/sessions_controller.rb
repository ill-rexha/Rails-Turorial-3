class SessionsController < ApplicationController
  def new

  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	# only success if system find usr by email and password authenticate
  	if user && user.authenticate(paramns[:session][:password])

  	else 
    flash[:danger] = 'Invalid email/password combination'
  	render "new"
  	end
  end

  def destroy
  end
end
