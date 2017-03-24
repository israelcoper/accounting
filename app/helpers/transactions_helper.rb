module TransactionsHelper

  def transaction_link(t)
    link_to t.transaction_number, "#", data: { toggle: "popover", trigger: "focus", placement: "right", original_title: "##{t.transaction_number} transaction", account_id: t.account.id, transaction_id: t.id }, class: "transaction-link"
  end

  def transaction_status(status)
    return nil if status.nil?
    label = case status
            when Transaction::Status[0]
              "default"
            when Transaction::Status[1]
              "primary"
            when Transaction::Status[2]
              "info"
            else
              "success"
            end
    content_tag :span, status, class: "label label-#{label}"
  end

  def sales_action(record=nil, opt={})
    case record.try(:status)
    when Transaction::Status[0]
      link_to "Receive payment", payment_account_transaction_path(current_account, record)
    when Transaction::Status[2]
      link_to "Receive payment", payment_account_transaction_path(current_account, record)
    when Transaction::Status[1]
      link_to "Preview", preview_account_transaction_path(current_account, record)
    when Transaction::Status[3]
      link_to "Preview", preview_account_transaction_path(current_account, record)
    else
      link_to "Create invoice", invoice_account_transactions_path(current_account, { person_id: opt[:person_id] })
    end
  end

  def purchases_action(record=nil, opt={})
    case record.try(:status)
    when Transaction::Status[0]
      link_to "Pay order", payment_purchase_account_transaction_path(current_account, record)
    when Transaction::Status[2]
      link_to "Pay order", payment_purchase_account_transaction_path(current_account, record)
    when Transaction::Status[1]
      link_to "Preview", preview_account_transaction_path(current_account, record)
    when Transaction::Status[3]
      link_to "Preview", preview_account_transaction_path(current_account, record)
    else
      link_to "Purchase order", purchase_account_transactions_path(current_account, { person_id: opt[:person_id] })
    end
  end

  def person_id(record, params={})
    return Person.find(params[:person_id]).try(:id) if params[:person_id].present?
    return record.present? ? record.person.try(:id) : nil
  end

  def total_balance(transactions)
    transactions.inject(0) {|result,t| result += t.balance}
  end

  def total_paid(transactions)
    transactions.inject(0) {|result,t| result += t.total}
  end

  def option_customers
    current_account.customers.map {|person| [person.full_name, person.id]}.push ["---- Add customer ----", "new"]
  end

  def option_suppliers
    current_account.suppliers.map {|person| [person.full_name, person.id]}.push ["---- Add supplier ----", "new"]
  end

  def option_products
    current_account.products.map {|product| [product.name, product.id]}.push ["---- Add product ----", "new"]
  end

end
