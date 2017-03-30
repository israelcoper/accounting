class Item < ActiveRecord::Base
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id
  belongs_to :product

  after_save :update_quantity_and_income, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[0]}
  after_save :update_quantity_and_cost, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[2]}
  after_save :update_cost, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[4]}
  after_destroy :cancel_invoice!, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[0]}
  after_destroy :cancel_purchase!, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[2]}
  after_destroy :cancel_expense!, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::Types[4]}

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

  def cancel_invoice!
    self.product.quantity += quantity
    self.product.income -= amount
    self.product.save
  end

  def cancel_purchase!
    self.product.quantity -= quantity
    self.product.cost -= amount
    self.product.save
  end

  def cancel_expense!
    self.product.cost -= amount
    self.product.save
  end
end
