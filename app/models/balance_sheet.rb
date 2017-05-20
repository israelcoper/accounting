class BalanceSheet < ActiveRecord::Base
  belongs_to :account

  default_scope { order(account_number: "ASC") }

  # TODO REFACTOR
  scope :income, -> { where("account_number BETWEEN ? AND ?", "4-1100", "4-1900") }
  scope :other_income, -> { where("account_number BETWEEN ? AND ?", "8-1000", "8-9000") }
  scope :cost_of_sales, -> { where("account_number BETWEEN ? AND ?", "5-1100", "5-1900") }

  def self.template
    YAML::load_file Rails.root.join('config', 'accounts.yml')
  end
end
