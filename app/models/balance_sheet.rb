class BalanceSheet < ActiveRecord::Base
  belongs_to :account

  # enum category: [ :current_asset, :non_current_asset, :liability, :equity ]

  # scope :current_assets, -> { where(category: BalanceSheet.categories["current_asset"]) }
  # scope :non_current_assets, -> { where(category: BalanceSheet.categories["non_current_asset"]) }
  # scope :liabilities, -> { where(category: BalanceSheet.categories["liability"]) }
  # scope :equity, -> { where(category: BalanceSheet.categories["equity"]) }

  # before_save :set_withdrawals_value, if: proc { |balance_sheet| balance_sheet.name.eql?("Withdrawals") }

  # protected
  # def set_withdrawals_value
  #   self.amount = -amount
  # end
  def self.template
    YAML::load_file Rails.root.join('config', 'accounts.yml')
  end
end
