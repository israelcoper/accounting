class Person < ActiveRecord::Base
  include PgSearch
  include UserPersonHelper

  self.table_name = "persons"

  enum person_type: [:customer, :supplier, :employee]

  default_scope { order(first_name: "ASC") }

  scope :customers, -> { where(person_type: 0) }
  scope :suppliers, -> { where(person_type: 1) }
  scope :employees, -> { where(person_type: 2) }

  belongs_to :account
  has_many :transactions

  validates :first_name, :last_name, :phone, presence: true
  # Change uniqueness validation
  validates :first_name, :last_name, uniqueness: { scope: [:account_id, :person_type] }

  paginates_per 10

  pg_search_scope :search, against: [:first_name, :last_name]
end
