class Item < ActiveRecord::Base
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id
  belongs_to :product

  after_save :update_quantity_and_income_of_rice_item, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::TransactionTypes[0] && item.product.product_type == "rice"}
  after_save :update_quantity_and_income_of_grocery_item, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::TransactionTypes[0] && item.product.product_type == "grocery_item"}
  after_save :update_quantity_and_cost_of_rice_item, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::TransactionTypes[2] && item.product.product_type == "rice"}
  after_save :update_quantity_and_cost_of_grocery_item, if: Proc.new {|item| item.negotiation.transaction_type == Transaction::TransactionTypes[2] && item.product.product_type == "grocery_item"}

  protected

  def update_quantity_and_income_of_rice_item
    self.product.fields["number_of_kilo"] = (product.fields["number_of_kilo"].to_i - quantity).to_s
    self.product.fields["number_of_sack"] = (product.fields["number_of_kilo"].to_i / product.fields["average_kilo_per_sack"].to_f).to_s
    self.product.income += amount
    self.product.save
  end

  def update_quantity_and_income_of_grocery_item
    self.product.fields["quantity"] = (product.fields["quantity"].to_i - quantity).to_s
    self.product.income += amount
    self.product.save
  end

  def update_quantity_and_cost_of_rice_item
    self.product.fields["number_of_kilo"] = (product.fields["number_of_kilo"].to_i + quantity).to_s
    self.product.fields["number_of_sack"] = (product.fields["number_of_kilo"].to_i / product.fields["average_kilo_per_sack"].to_f).to_s
    self.product.cost += amount
    self.product.save
  end

  def update_quantity_and_cost_of_grocery_item
    self.product.fields["quantity"] = (product.fields["quantity"].to_i + quantity).to_s
    self.product.cost += amount
    self.product.save
  end
end
