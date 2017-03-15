class AccountsController < ApplicationController
  skip_before_action :current_user_has_account!
  skip_before_action :current_account_has_account_chart!, except: [:show, :edit, :update]
  before_action :find_account, only: [:show, :edit, :update, :new_chart, :chart]

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

  def new_chart
    BalanceSheet::Template.each do |category,names|
      names.each do |name|
        @account.balance_sheets.build(category: category, name: name)
      end
    end
  end

  def chart
    @account.update(account_params.except(:address))
    redirect_to account_products_path(@account), notice: "Chart of Accounts created successfully"
  end

  protected

  def account_params
    params.require(:account).permit(:name, :industry, balance_sheets_attributes: [:id, :name, :category, :amount, :_destroy]).tap do |whitelist|
      whitelist[:address] = params[:account][:address]
    end
  end

  def find_account
    @account ||= Account.find(params[:id])
  end
end
