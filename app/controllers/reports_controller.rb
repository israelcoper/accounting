class ReportsController < ApplicationController
  def index
    @default_year = Date.today.strftime("%Y")
  end

  def income_statement
    @year = params[:date_year].present? ? params[:date_year].to_i : Date.today.strftime("%Y").to_i      
    from  = Date.new(@year)
    to    = Date.new(@year, 12, 31)
    range = from..to

    @products = current_account.products.inventory.income_statement(range)
    @expenses = current_account.products.non_inventory.income_statement(range)
    @total_income = current_account.total_income(@products)
    @total_cost = current_account.total_cost(@products)
    @total_expenses = current_account.total_cost(@expenses)

    @gross_profit = @total_income + @total_cost
    @net_income = @gross_profit + @total_expenses

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "income_statement", filename: "Income statement - 31 December #{@year}.xlsx" }
    end
  end

  def balance_sheet
    income_statement

    @current_assets = current_account.balance_sheets.current_assets
    @non_current_assets = current_account.balance_sheets.non_current_assets
    @liabilities = current_account.balance_sheets.liabilities
    @equity = current_account.balance_sheets.equity

    @total_current_assets = @current_assets.map(&:amount).inject(:+)
    @total_non_current_assets = @non_current_assets.map(&:amount).inject(:+)
    @total_assets = @total_current_assets + @total_non_current_assets
    @total_liabilities = @liabilities.map(&:amount).inject(:+)
    @total_equity = @equity.map(&:amount).inject(:+) + @net_income

    @asset = @total_liabilities + @total_equity
  end
end
