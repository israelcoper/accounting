class Person < ActiveRecord::Base
  include PgSearch
  include UserPersonHelper

  self.table_name = "persons"

  enum person_type: [:customer, :supplier, :employee]

  scope :customers, -> { where(person_type: 0) }
  scope :suppliers, -> { where(person_type: 1) }

  belongs_to :account

  validates :first_name, :last_name, :phone, presence: true

  paginates_per 10

  pg_search_scope :search, against: [:first_name, :last_name]
end
