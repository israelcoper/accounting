class CustomersController < ApplicationController
  before_action :find_customer, only: [:show, :edit, :update, :destroy, :transactions, :info]

  def index
    type          = Transaction::Types[0]
    last_30_days  = 30.days.ago..Time.now
    last_60_days  = 60.days.ago..31.days.ago
    last_90_days  = 90.days.ago..61.days.ago
    over_90_days  = 120.days.ago..91.days.ago

     @transactions_summary = {
      overdue_last_30_days: current_account.transactions.overdue(type, last_30_days),
      overdue_last_60_days: current_account.transactions.overdue(type, last_60_days),
      overdue_last_90_days: current_account.transactions.overdue(type, last_90_days),
      overdue_over_90_days: current_account.transactions.overdue(type, over_90_days)
    }

    @customers = current_account.customers.page(page)
    if params[:search].present?
      @customers = current_account.customers.search(params[:search]).page(page)
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: CustomerTransactionsDatatable.new(view_context, {customer: @customer}) }
    end
  end

  def new
    @customer = Person.new
  end

  def create
    @customer = Person.new(customer_params.merge(account: current_account, person_type: Person.person_types["customer"]))
    if @customer.save
      flash[:notice] = "#{@customer.full_name} was successfully created"
      redirect_to request.referrer
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      flash[:notice] = "#{@customer.full_name} was successfully updated"
      redirect_to account_customers_path(current_account)
    else
      render :edit
    end
  end

  def destroy
  end

  def transactions
    @transactions = @customer.transactions.invoice
    render json: @transactions
  end

  def info
    render json: { credit_terms: @customer.credit_terms }
  end

  protected

  def customer_params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :phone, :mobile, :notes, :credit_limit, :credit_terms, :picture).tap do |whitelist|
      whitelist[:address] = params[:person][:address]
    end
  end

  def find_customer
    @customer ||= Person.find(params[:id])
  end
end
