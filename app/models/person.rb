class Person < ActiveRecord::Base
  include PgSearch
  include UserPersonHelper

  self.table_name = "persons"

  CREDIT_TERMS = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300]

  paginates_per 10
  pg_search_scope :search, against: [:first_name, :last_name]
  has_attached_file :picture, styles: { small: "100x100>", medium: "200x200>", large: "300x300>" }, default_url: "/images/:style/missing.png"

  enum person_type: [:customer, :supplier, :employee]

  default_scope { order(first_name: "ASC") }

  scope :customers, -> { where(person_type: 0) }
  scope :suppliers, -> { where(person_type: 1) }
  scope :employees, -> { where(person_type: 2) }

  belongs_to :account
  has_many :transactions

  validates :first_name, :last_name, presence: true
  # Change uniqueness validation
  validates :first_name, :last_name, uniqueness: { scope: [:account_id, :person_type, :first_name, :last_name] }
  validates :credit_limit, :credit_terms, presence: true, numericality: true, unless: Proc.new {|p| p.employee? }

  # validates_attachment_presence :picture, unless: Proc.new {|p| p.picture? }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
end
