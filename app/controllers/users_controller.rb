class UsersController < ApplicationController
  before_action :login?, only: %i(show edit update)		
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user?, only: %i(edit update)
  before_action :valid_admin?, only: [:destroy]
 	 def index
 	 	@users = User.paginate(page: params[:page], per_page: 20)
 	 end
 	 def show;
	end

	def new
	@user = User.new
	end
	def edit
	end
	def update
		if @user.update user_params
			flash[:success] = "Update successful"
			redirect_to @user
		else
			flash.now[:danger] = "Update fail!!!"
			render :edit
		end
	end
	def destroy
		if @user.destroy
			flash[:success] = "Delete account successful"
		else
			flash.now[:danger] = "Delete fail!!!"
		end
			redirect_to users_path
	end
	def create
		@user = User.new user_params
		 if @user.save
		 	flash[:success] = "Create account successful!!!"
		 	redirect_to @user
		else
			flash.now[:danger] = "Create user fail !!!"
		 	render :new
		end
	end
private
def user_params
	params.require(:user).permit :name,		
	:email, :password, :password_confirmation	
end
def load_user
	@user = User.find_by id: params[:id]	
	  	unless @user
	  		flash[:danger] = "User not found user_id: #{params[:id]	}"
	  		redirect_to root_path
	  	end
end
def correct_user?
	if @user != current_user
			flash[:danger] = "Access denied"
			redirect_to root_path
	end
end
def valid_admin?
 	unless current_user.is_admin
 	 	flash[:danger] = "Access denied"
			redirect_to users_path
 	 end 	
end
end

