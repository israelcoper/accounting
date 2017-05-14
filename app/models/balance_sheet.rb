class BalanceSheet < ActiveRecord::Base
  belongs_to :account

  # scope :current_assets, -> { where(category: BalanceSheet.categories["current_asset"]) }
  # scope :non_current_assets, -> { where(category: BalanceSheet.categories["non_current_asset"]) }
  # scope :liabilities, -> { where(category: BalanceSheet.categories["liability"]) }
  # scope :equity, -> { where(category: BalanceSheet.categories["equity"]) }

  default_scope { order(account_number: "ASC") }

  def self.template
    YAML::load_file Rails.root.join('config', 'accounts.yml')
  end
end
