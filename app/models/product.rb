class Product < ActiveRecord::Base

  Units = %w{ kilo liter pack piece unit }

  default_scope { order(name: "ASC") }

  belongs_to :account

  validates :name, :unit, presence: true
  validates :income, numericality: true, allow_blank: true
  validates :cost, :purchasing_price, :selling_price, :quantity, numericality: true

end
