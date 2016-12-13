class CustomersController < ApplicationController
  before_action :find_customer, only: [:show, :edit, :update, :destroy]

  def index
    @customers = current_account.persons.customers
  end

  def show
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
