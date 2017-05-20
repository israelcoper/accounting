class TransactionItem < ActiveRecord::Base
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id
  belongs_to :item

  after_save :update_quantity_and_income, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[0]}
  after_save :update_quantity_and_cost, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[2]}
  after_save :update_cost, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[4]}

  scope :yearly_expenses, ->(account_id, from, to) { joins("INNER JOIN products ON items.product_id = products.id INNER JOIN transactions ON items.transaction_id = transactions.id WHERE products.category = 1 AND transactions.cancelled = 'f' AND transactions.account_id = #{account_id} AND transactions.created_at BETWEEN '#{from}' AND '#{to}'").group("products.name").sum("items.amount") }

  protected

  def update_quantity_and_income
    self.product.quantity -= quantity
    self.product.income += amount
    self.product.save
  end

  def update_quantity_and_cost
    self.product.quantity += quantity
    self.product.cost += amount
    self.product.save
  end

  def update_cost
    self.product.cost += amount
    self.product.save
  end
end
