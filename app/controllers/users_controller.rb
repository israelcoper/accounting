class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = current_user.account.users.non_admin
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    @user.account = current_user.account
    if @user.save
      flash[:notice] = "#{@user.full_name} was successfully created"
      redirect_to edit_user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{@user.full_name} was successfully updated"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "#{@user.full_name} was successfully deleted"
  end

  protected

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :password, :password_confirmation, :role)
  end

  def find_user
    @user ||= User.find(params[:id])
  end

end
