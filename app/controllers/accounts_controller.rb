class AccountsController < ApplicationController
  skip_before_action :current_user_has_account!
  before_action :find_account, only: [:show, :edit, :update, :update_chart_of_accounts]

  def new
    @account = Account.new
    BalanceSheet.template.each do |key,value|
      @account.balance_sheets.build(account_number: key, name: value.fetch("name"), header: value.fetch("header"))
    end
    render layout: 'account'
  end

  def create
    @account = Account.new account_params
    if @account.save
      flash[:notice] = "Welcome"
      current_user.update_attributes(role: User.roles["admin"], account: @account)
      redirect_to account_items_path(@account)
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

  def update_chart_of_accounts
    @account.update_attributes chart_of_account_params
    flash[:notice] = "Chart of accounts updated successfully"
    redirect_to account_chart_of_accounts_path(@account)
  end

  protected

  def account_params
    params.require(:account).permit(:name, :industry, balance_sheets_attributes: [:id, :header, :account_number, :name, :opening_balance, :_destroy]).tap do |whitelist|
      whitelist[:address] = params[:account][:address]
    end
  end

  def chart_of_account_params
    params.require(:account).permit(balance_sheets_attributes: [:id, :header, :account_number, :name, :opening_balance, :_destroy])
  end

  def find_account
    @account ||= Account.find(params[:id])
  end
end
