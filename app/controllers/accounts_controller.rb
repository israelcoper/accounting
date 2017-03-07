class AccountsController < ApplicationController
  skip_before_action :current_user_has_account!
  before_action :find_account, only: [:show, :edit, :update]

  def new
    @account = Account.new
    render layout: 'account'
  end

  def create
    @account = Account.new account_params
    if @account.save
      flash[:notice] = "Welcome"
      current_user.update_attributes(role: User.roles["admin"], account: @account)
      redirect_to root_path
    else
      flash[:error] = "Something went wrong"
      render :new, layout: 'account'
    end
  end

  def show
    authorize @account
  end

  def edit
    authorize @account
  end

  def update
    authorize @account
    if @account.update_attributes account_params
      flash[:notice] = "Company information updated successfully"
      redirect_to account_path(@account)
    else
      render :edit
    end
  end

  protected

  def account_params
    params.require(:account).permit(:name, :industry).tap do |whitelist|
      whitelist[:address] = params[:account][:address]
    end
  end

  def find_account
    @account ||= Account.find(params[:id])
  end
end
