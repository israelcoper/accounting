class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize User
    @users = current_account.users.non_admin
  end

  def new
    @user = User.new
    authorize @user
  end
  
  def create
    @user = User.new(user_params)
    authorize @user
    @user.account = current_user.account
    if @user.save
      flash[:notice] = "#{@user.full_name} was successfully created"
      redirect_to edit_account_user_path(current_account, @user)
    else
      render :new
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      flash[:notice] = "#{@user.full_name} was successfully updated"
      redirect_to edit_account_user_path(current_account, @user)
    else
      render :edit
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to account_users_path(current_account), notice: "#{@user.full_name} was successfully deleted"
  end

  protected

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :password, :password_confirmation, :role)
  end

  def find_user
    @user ||= User.find(params[:id])
  end

end
