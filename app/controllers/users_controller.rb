class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy, :reset_password, :reset, :lock, :unlock]

  def index
    authorize User
    @users = current_account.users.non_admin.page(page)
    if params[:search].present?
      @users = current_account.users.non_admin.search(params[:search]).page(page)
    end
  end

  def new
    @user = User.new
    authorize @user
  end
  
  def create
    @user = User.new(user_params)
    authorize @user
    @user.account = current_account
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

  def lock
    @user.locked
    redirect_to account_users_path(current_account), notice: "#{@user.full_name} has been locked."
  end

  def unlock
    @user.unlocked
    redirect_to account_users_path(current_account), notice: "#{@user.full_name} has been unlocked."
  end

  def reset_password
  end

  def reset
    if @user.update(password_params)
      sign_in @user, bypass: true if @user == current_user
      redirect_to account_users_path(current_account, @user), notice: t('flash.notice.reset_password')
    else
      render :reset_password
    end
  end

  protected

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :password, :password_confirmation, :role)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def find_user
    @user ||= User.find(params[:id])
  end

end
