class Transaction < ActiveRecord::Base

  TransactionTypes = %w{ Invoice Payment }
  Status = %w{ Open Closed Partial Paid }

  belongs_to :account
  belongs_to :person
  belongs_to :parent, class_name: "Transaction"
  has_many :children, class_name: "Transaction", foreign_key: :parent_id
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc {|attributes| attributes["quantity"].blank? }

  scope :sales, -> { where(transaction_type: "Invoice") }

  before_save :generate_transaction_number, if: Proc.new {|t| t.new_record? && t.transaction_type == TransactionTypes[0]}
  before_save :sales_default_status, if: Proc.new {|t| t.new_record? && t.transaction_type == TransactionTypes[0]}

  protected

  def generate_transaction_number
    self.transaction_number = SecureRandom.hex(4).upcase
  end

  def sales_default_status
    self.status = Status[0]
  end

end
