class EmployeesController < ApplicationController
  before_action :find_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = current_account.employees.page(page)
    if params[:search].present?
      @employees = current_account.employees.search(params[:search]).page(page)
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: EmployeeTransactionsDatatable.new(view_context, {employee: @employee}) }
    end
  end

  def new
    @employee = Person.new
  end

  def create
    @employee = Person.new(employee_params.merge(account: current_account, person_type: Person.person_types["employee"]))
    if @employee.save
      flash[:notice] = "#{@employee.full_name} was successfully created"
      redirect_to request.referrer
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      flash[:notice] = "#{@employee.full_name} was successfully updated"
      redirect_to account_employees_path(current_account)
    else
      render :edit
    end
  end

  def destroy
  end

  protected

  def employee_params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :phone, :mobile, :picture).tap do |whitelist|
      whitelist[:address] = params[:person][:address]
    end
  end

  def find_employee
    @employee ||= Person.find(params[:id])
  end
end
