class ReportsController < ApplicationController
  def index
  end

  def income_statement
    year  = params[:date][:year].to_i      
    from  = Date.new(year)
    to    = Date.new(year, 12, 31)
    range = from..to

    @products = current_account.products.inventory.income_statement(range)
    @expenses = current_account.products.non_inventory.income_statement(range)
    @total_income = current_account.total_income(@products)
    @total_cost = current_account.total_cost(@products)
    @total_expenses = current_account.total_cost(@expenses)

    @gross_profit = @total_income + @total_cost
    @net_income = @gross_profit + @total_expenses
  end
end
