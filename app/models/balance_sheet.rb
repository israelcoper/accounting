class BalanceSheet < ActiveRecord::Base
  belongs_to :account
  has_many :balances, dependent: :destroy

  default_scope { order(account_number: "ASC") }

  # TODO REFACTOR
  scope :sales_items, -> { where("account_number BETWEEN ? AND ?", "4-1100", "4-1900") }
  scope :purchases_items, -> { where("account_number BETWEEN ? AND ?", "5-1100", "5-1900") }

  scope :cash_equivalents, -> { where("account_number BETWEEN ? AND ?", "1-1110", "1-1190") }
  scope :advances_to_employees, -> { where("account_number BETWEEN ? AND ?", "1-1310", "1-1390") }
  scope :assets_a, -> { where("account_number BETWEEN ? AND ?", "1-1410", "1-1490") }
  scope :assets_b, -> { where("account_number BETWEEN ? AND ?", "1-1510", "1-1590") }

  scope :building, -> { where("account_number BETWEEN ? AND ?", "1-2110", "1-2190") }
  scope :vehicles, -> { where("account_number BETWEEN ? AND ?", "1-2210", "1-2290") }

  scope :current_liabilities, -> { where("account_number BETWEEN ? AND ?", "2-1100", "2-1900") }
  scope :non_current_liabilities, -> { where("account_number BETWEEN ? AND ?", "2-2100", "2-2900") }

  scope :equities, -> { where("account_number BETWEEN ? AND ?", "3-1100", "3-1900") }

  # scope :employment_expenses, -> { where("account_number BETWEEN ? AND ?", "6-1011", "6-1019") }
  # scope :food_expenses, -> { where("account_number BETWEEN ? AND ?", "6-1021", "6-1029") }
  # scope :expenses, -> { where("account_number BETWEEN ? AND ?", "6-1030", "6-1200") }
  scope :other_income, -> { where("account_number BETWEEN ? AND ?", "8-1000", "8-9000") }

  # scope :income_statement, -> (st, en, fr, to) { includes(:balances).where("balance_sheets.account_number BETWEEN ? AND ?", st, en).where("balances.created_at BETWEEN ? AND ?", fr, to).references(:balances) }

  before_save :update_current_balance

  INCOME = ("4-0000".."4-9000")
  COST_OF_SALES = ("5-0000".."5-9000")

  def self.template
    YAML::load_file Rails.root.join('config', 'accounts.yml')
  end

  def income_statement(fr, to)
    balances.income_statement(fr, to).sum(:balance)
  end

  protected

  def update_current_balance
    self.current_balance = current_balance + opening_balance - temp_balance
    self.temp_balance = opening_balance
  end
end
