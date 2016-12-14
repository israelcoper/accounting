class SuppliersController < ApplicationController
  before_action :find_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = current_account.persons.suppliers.page(page)
    if params[:search].present?
      @suppliers = current_account.persons.suppliers.search(params[:search]).page(page)
    end
  end

  def show
  end

  def new
    @supplier = Person.new
  end

  def create
    @supplier = Person.new(supplier_params.merge(account: current_account, person_type: Person.person_types["supplier"]))
    if @supplier.save
      flash[:notice] = "#{@supplier.full_name} was successfully created"
      redirect_to account_suppliers_path(current_account)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      flash[:notice] = "#{@supplier.full_name} was successfully updated"
      redirect_to account_suppliers_path(current_account)
    else
      render :edit
    end
  end

  def destroy
  end

  protected

  def supplier_params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :phone, :mobile).tap do |whitelist|
      whitelist[:address] = params[:person][:address]
    end
  end

  def find_supplier
    @supplier ||= Person.find(params[:id])
  end
end
