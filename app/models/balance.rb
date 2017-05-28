class Balance < ActiveRecord::Base
  belongs_to :balance_sheet
  belongs_to :transaction_item

  scope :income_statement, -> (fr, to) { where("created_at BETWEEN ? AND ?", fr, to) }
end
