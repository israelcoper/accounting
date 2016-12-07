class AccountsController < ApplicationController
  skip_before_action :current_user_has_account!

  def new
    @account = Account.new
    render layout: 'account'
  end

  def create
    @account = Account.new account_params
    if @account.save
      flash[:notice] = "Welcome"
      current_user.update_attributes(role: User::Role.fetch(0), account: @account)
      redirect_to root_path
    else
      flash[:error] = "Something went wrong"
      render :new, layout: 'account'
    end
  end

  protected

  def account_params
    params.require(:account).permit(:name).tap do |whitelist|
      whitelist[:address] = params[:account][:address]
    end
  end
end
