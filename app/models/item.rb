class Item < ActiveRecord::Base
  Units = %w{ none hour kilo liter pack piece unit }

  default_scope { order(item_number: "ASC") }

  belongs_to :account

  validates :item_number, :unit, presence: true
  validates :name, presence: true, uniqueness: true
  validates :purchase_price, :selling_price, numericality: true
end
