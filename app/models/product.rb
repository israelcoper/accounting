class Product < ActiveRecord::Base

  Units = %w{ kilo liter pack piece unit }

  default_scope { order(name: "ASC") }

  belongs_to :account

  validates :name, :unit, :product_number, presence: true
  validates :income, numericality: true, allow_blank: true
  validates :cost, :purchase_price, :selling_price, :quantity, numericality: true

end
