class SessionsController < ApplicationController
  def new
  end
  def create
  	@user = User.find_by email: params[:session][:email].downcase
  	if @user.present? && @user.authenticate(params[:session][:password])
    		if @user.activated?
           login_user @user
            #kiem tra end user co remember hay k
           (params[:session][:remember_me] == "1") ? remember(@user) : forget(@user)
           flash[:success] = "Login successful"
            redirect_to @user
          else
          message = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
      end        
  	else
  		flash.now[:danger] = "Email or Password is Incorrect!!"
  		render :new
  	end
  end
  def destroy
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
    flash[:success] = "Goodbye"
      redirect_to root_path
    
  end
end
