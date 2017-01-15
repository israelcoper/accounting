class Transaction < ActiveRecord::Base

  TransactionTypes = %w{ Invoice Payment }
  Status = %w{ Open Closed Partial Paid }

  belongs_to :account
  belongs_to :person
  belongs_to :parent, class_name: "Transaction"
  has_many :children, class_name: "Transaction", foreign_key: :parent_id
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc {|attributes| attributes["quantity"].blank? }

  default_scope { order(transaction_date: "ASC") }
  scope :sales, -> { where(transaction_type: TransactionTypes.values_at(0,1)) }
  scope :invoice, -> { where(transaction_type: TransactionTypes[0], status: [Status[0], Status[2]]) }

  before_save :set_status, if: proc {|t| t.new_record? }
  before_save :generate_transaction_number, if: proc {|t| t.transaction_type == TransactionTypes[0]}
  before_save :set_invoice_payment_total, if: proc {|t| t.transaction_type == TransactionTypes[1]}

  after_save :deduct_balance_of_parent_invoice, if: proc {|t| t.transaction_type == TransactionTypes[1]}
  after_save :update_status_of_parent_invoice, if: proc {|t| t.transaction_type == TransactionTypes[1]}

  validates :balance, numericality: true, allow_blank: true

  def add_balance_to_customer
    self.person.balance += balance
    self.person.save
  end

  def deduct_balance_of_customer
    self.person.balance -= payment
    self.person.save
  end

  protected

  def generate_transaction_number
    self.transaction_number = SecureRandom.hex(4).upcase
  end

  def set_status
    self.status = case transaction_type
                  when TransactionTypes[0]
                    Status[0]
                  when TransactionTypes[1]
                    Status[1]
                  else
                  end
  end

  def set_invoice_payment_total
    self.total = -payment
  end

  def deduct_balance_of_parent_invoice
    self.parent.balance -= payment
    self.parent.save
  end

  def update_status_of_parent_invoice
    new_status = (parent.balance == 0.0) ? Status[3] : Status[2]
    self.parent.update(status: new_status)
  end

end
