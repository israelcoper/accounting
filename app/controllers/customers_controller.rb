class CustomersController < ApplicationController
  before_action :find_customer, only: [:show, :edit, :update, :destroy, :transactions]

  def index
    type = Transaction::TransactionTypes[0]
    @transactions_summary = {
      overdue: Transaction.overdue(type),
      open_invoice: Transaction.open_invoice(type),
      partial: Transaction.partial(type),
      paid_last_30_days: Transaction.paid_last_30_days(type)
    }

    @customers = current_account.customers.page(page)
    if params[:search].present?
      @customers = current_account.customers.search(params[:search]).page(page)
    end
  end

  def show
    @transactions = @customer.transactions.sales(transaction_filter).page(page)
  end

  def new
    @customer = Person.new
  end

  def create
    @customer = Person.new(customer_params.merge(account: current_account, person_type: Person.person_types["customer"]))
    if @customer.save
      flash[:notice] = "#{@customer.full_name} was successfully created"
      redirect_to account_customers_path(current_account)
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

  protected

  def customer_params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :phone, :mobile).tap do |whitelist|
      whitelist[:address] = params[:person][:address]
    end
  end

  def find_customer
    @customer ||= Person.find(params[:id])
  end
end
