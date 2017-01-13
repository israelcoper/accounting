class Item < ActiveRecord::Base
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id
  belongs_to :product

  after_save :update_product_rice, if: Proc.new {|item| item.product.product_type == "rice"}

  protected

  def update_product_rice
    self.product.fields["number_of_kilo"] = (product.fields["number_of_kilo"].to_i - quantity).to_s
    self.product.fields["number_of_sack"] = (product.fields["number_of_kilo"].to_i / product.fields["average_kilo_per_sack"].to_f).to_s
    self.product.income = amount
    self.product.save
  end
end
