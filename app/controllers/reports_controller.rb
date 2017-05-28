class ReportsController < ApplicationController
  def index
    @default_year = Date.today.strftime("%Y")
  end

  def income_statement
    financial_statement

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "income_statement", filename: "Income statement - 31 December #{@year}.xlsx" }
    end
  end

  def balance_sheet
    financial_statement

    # TODO: REFACTOR
    # CURRENT ASSETS
    @cash_equivalents_items = current_account.balance_sheets.cash_equivalents
    @cash_equivalents = current_account.balance_sheets.find_by_account_number("1-1100")
    @accounts_receivable = current_account.balance_sheets.find_by_account_number("1-1200")
    @advances_to_employees_items = current_account.balance_sheets.advances_to_employees
    @advances_to_employees = current_account.balance_sheets.find_by_account_number("1-1300")
    @assets_a_items = current_account.balance_sheets.assets_a
    @assets_a = current_account.balance_sheets.find_by_account_number("1-1400")
    @assets_b_items = current_account.balance_sheets.assets_b
    @assets_b = current_account.balance_sheets.find_by_account_number("1-1500")
    @current_assets = current_account.balance_sheets.find_by_account_number("1-1000")

    # NON CURRENT ASSETS
    @building_items = current_account.balance_sheets.building
    @building = current_account.balance_sheets.find_by_account_number("1-2100")
    @vehicles_items = current_account.balance_sheets.vehicles
    @vehicles = current_account.balance_sheets.find_by_account_number("1-2200")
    @non_current_assets = current_account.balance_sheets.find_by_account_number("1-2000")

    @assets = current_account.balance_sheets.find_by_account_number("1-0000")

    # CURRENT LIABILITY
    @current_liability_items = current_account.balance_sheets.current_liabilities
    @current_liability = current_account.balance_sheets.find_by_account_number("2-1000")

    # NON CURRENT LIABILITY
    @non_current_liability_items = current_account.balance_sheets.non_current_liabilities
    @non_current_liability = current_account.balance_sheets.find_by_account_number("2-2000")

    @liability = current_account.balance_sheets.find_by_account_number("2-0000")

    # EQUITY
    @equities = current_account.balance_sheets.equities
    @equity = current_account.balance_sheets.find_by_account_number("3-0000")

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "balance_sheet", filename: "Balance Sheet - 31 December #{@year}.xlsx" }
    end
  end

  private

  # TODO: REFACTOR
  def financial_statement
    @year = params[:date_year].present? ? params[:date_year].to_i : Date.today.strftime("%Y").to_i      
    @fr   = Date.new(@year)
    @to   = Date.new(@year, 12, 31)

    @sales_items = current_account.balance_sheets.sales_items
    @sales = current_account.balance_sheets.find_by_account_number("4-1000")
    @income = current_account.balance_sheets.find_by_account_number("4-0000")

    @purchases_items = current_account.balance_sheets.purchases_items
    @purchases = current_account.balance_sheets.find_by_account_number("5-1000")
    @cost_of_sales = current_account.balance_sheets.find_by_account_number("5-0000")

    # @employment_expenses = current_account.balance_sheets.employment_expenses
    # @food_expenses = current_account.balance_sheets.food_expenses
    # @expenses = current_account.balance_sheets.expenses

    @gross_profit = @income.income_statement(@fr, @to) - @cost_of_sales.income_statement(@fr, @to)
    # @net_income = @gross_profit - @total_expenses
  end
end
