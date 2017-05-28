class TransactionItem < ActiveRecord::Base
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id
  belongs_to :item
  has_one :balance

  after_save :update_chart_of_account

  # scope :income_statement, ->(account_id, fr, to) { joins("INNER JOIN items ON transaction_items.item_id = items.id INNER JOIN transactions ON transaction_items.transaction_id = transactions.id WHERE transactions.cancelled = 'f' AND transactions.account_id = #{account_id} AND transactions.created_at BETWEEN '#{fr}' AND '#{to}'").group("items.item_number").sum("transaction_items.amount") }

  protected

  # TODO: REFACTOR
  def update_chart_of_account
    bs = case negotiation.transaction_type
         when Transaction::Types.fetch(0)
           BalanceSheet.find(item.allocated_to_selling)
         when Transaction::Types.fetch(2)
           BalanceSheet.find(item.allocated_to_purchase)
         when Transaction::Types.fetch(4)
         end

    bs.balances.create(transaction_item: self, balance: amount)
    bs.current_balance += amount
    bs.save

    if BalanceSheet::INCOME.include?(bs.account_number)
      parent = negotiation.account.balance_sheets.where("account_number BETWEEN ? AND ?", "4-0000", "4-9000")
      sales = parent[1]
      income = parent[0]

      sales.balances.create(transaction_item: self, balance: amount)
      sales.current_balance += amount
      sales.save

      income.balances.create(transaction_item: self, balance: amount)
      income.current_balance += amount
      income.save
    elsif BalanceSheet::COST_OF_SALES.include?(bs.account_number)
      parent  = negotiation.account.balance_sheets.where("account_number BETWEEN ? AND ?", "5-0000", "5-9000")
      cost_of_sales = parent[1]
      purchases = parent[0]

      cost_of_sales.balances.create(transaction_item: self, balance: amount)
      cost_of_sales.current_balance += amount
      cost_of_sales.save

      purchases.balances.create(transaction_item: self, balance: amount)
      purchases.current_balance += amount
      purchases.save
    else
    end
  end
end
