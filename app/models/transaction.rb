class Transaction < ActiveRecord::Base

  TransactionTypes = ["Invoice", "Payment", "Purchase Order", "Purchase Payment"]
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
  scope :purchases, -> { where(transaction_type: TransactionTypes.values_at(2,3)) }
  scope :purchase_order, -> { where(transaction_type: TransactionTypes[2], status: [Status[0], Status[2]]) }

  scope :sales_overdue, -> { where("transaction_type = ? AND due_date <= ? AND balance != ?", TransactionTypes[0], Time.now, 0.0) }
  scope :open_invoice, -> { where(transaction_type: TransactionTypes[0], status: Status[0]) }
  scope :partial, -> { where(transaction_type: TransactionTypes[0], status: Status[2]) }
  scope :paid_last_30_days, -> { where("transaction_type = ? AND status = ? AND updated_at > ?", TransactionTypes[0], Status[3], 30.days.ago) }

  before_save :set_status, if: proc {|t| t.new_record? }
  before_save :set_total_of_payment_transaction, if: proc {|t| t.transaction_type == TransactionTypes[1]}
  before_save :set_total_of_purchase_payment_transaction, if: proc {|t| t.transaction_type == TransactionTypes[3]}
  before_save :generate_sal_invoice_number, if: proc {|t| t.new_record? && t.transaction_type == TransactionTypes[0]}
  before_save :generate_pur_invoice_number, if: proc {|t| t.new_record? && t.transaction_type == TransactionTypes[2]}

  after_save :deduct_balance_of_parent_invoice, if: proc {|t| t.transaction_type == TransactionTypes[1]}
  after_save :deduct_balance_of_parent_purchase, if: proc {|t| t.transaction_type == TransactionTypes[3]}
  after_save :update_status_of_parent_invoice, if: proc {|t| t.transaction_type == TransactionTypes[1]}
  after_save :update_status_of_parent_purchase, if: proc {|t| t.transaction_type == TransactionTypes[3]}

  validates :balance, numericality: true, allow_blank: true

  paginates_per 10

  class << self
    def total_overdue
      sales_overdue.inject(0) {|result,t| result += t.balance}
    end

    def total_open_invoice
      open_invoice.inject(0) {|result,t| result += t.balance}
    end

    def total_partial
      partial.inject(0) {|result,t| result += t.balance}
    end

    def total_paid_last_30_days
      paid_last_30_days.inject(0) {|result,t| result += t.total}
    end
  end

  def add_balance_to_person
    self.person.balance += balance
    self.person.save
  end

  def deduct_balance_of_person
    self.person.balance -= payment
    self.person.save
  end

  protected

  def generate_sal_invoice_number
    self.transaction_number = ["SAL" , SecureRandom.hex(4).upcase].join
  end

  def generate_pur_invoice_number
    self.transaction_number = ["PUR" , SecureRandom.hex(4).upcase].join
  end

  def set_status
    self.status = case transaction_type
                  when TransactionTypes[0]
                    Status[0]
                  when TransactionTypes[1]
                    Status[1]
                  when TransactionTypes[2]
                    Status[0]
                  when TransactionTypes[3]
                    Status[1]
                  else
                  end
  end

  def set_total_of_payment_transaction
    self.total = -payment
  end
  alias_method :set_total_of_purchase_payment_transaction, :set_total_of_payment_transaction

  def deduct_balance_of_parent_invoice
    self.parent.balance -= payment
    self.parent.save
  end
  alias_method :deduct_balance_of_parent_purchase, :deduct_balance_of_parent_invoice

  def update_status_of_parent_invoice
    new_status = (parent.balance == 0.0) ? Status[3] : Status[2]
    self.parent.update(status: new_status)
  end
  alias_method :update_status_of_parent_purchase, :update_status_of_parent_invoice

end
