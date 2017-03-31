class BalanceSheet < ActiveRecord::Base
  belongs_to :account

  enum category: [ :current_asset, :non_current_asset, :liability, :equity ]

  Template = {
    categories["current_asset"] => ["Cash & Cash Equivalents", "Accounts Receivable", "Advances to Employees", "Assets"],
    categories["non_current_asset"] => ["Building", "Vehicles"],
    categories["liability"] => ["Current Liability", "Non Current Liability"],
    categories["equity"] => ["Capital", "Withdrawals", "Retained Earnings"]
  }

  scope :current_assets, -> { where(category: BalanceSheet.categories["current_asset"]) }
  scope :non_current_assets, -> { where(category: BalanceSheet.categories["non_current_asset"]) }
  scope :liabilities, -> { where(category: BalanceSheet.categories["liability"]) }
  scope :equity, -> { where(category: BalanceSheet.categories["equity"]) }
end
