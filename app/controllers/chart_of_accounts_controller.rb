class ChartOfAccountsController < ApplicationController
  before_action :find_account

  def index
  end

  def new
  end

  def create
  end

  protected

  def find_account
    @account ||= Account.find(params[:account_id])
  end
end
