class Account < ActiveRecord::Base
  BusinessTypes = ["Agriculture", "Manufacturing", "Merchandising", "Retail", "Service", "Wholesale"]

  has_many :users, dependent: :destroy
  has_many :persons, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :categories, dependent: :destroy

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
end
