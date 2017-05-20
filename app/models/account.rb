class Account < ActiveRecord::Base
  BusinessTypes = ["Agriculture", "Manufacturing", "Merchandising", "Retail", "Service", "Wholesale"]

  has_many :users, dependent: :destroy
  has_many :persons, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :balance_sheets, dependent: :destroy
  has_many :activities, dependent: :destroy

  accepts_nested_attributes_for :balance_sheets, allow_destroy: true

  validates :name, :industry, presence: true

  def customers
    persons.customers
  end

  def suppliers
    persons.suppliers
  end

  def employees
    persons.employees
  end

  def total_income(product)
    return 0.0 if product.empty?
    product.map(&:income).inject(:+)
  end

  def total_cost(product)
    return 0.0 if product.empty?
    -product.map(&:cost).inject(:+)
  end
end
