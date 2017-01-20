module TransactionsHelper

  def format_date(date)
    return nil if date.nil?
    date.strftime "%m/%d/%Y"
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

  def sales_action(status, options={})
    case status
    when Transaction::Status[0] || Transaction::Status[2]
      link_to "Receive payment", payment_account_transactions_path(current_account, {parent_id: options[:parent_id], person_id: options[:person_id]})
    when Transaction::Status[3]
      link_to "Preview", preview_account_transaction_path(current_account, options[:parent_id])
    when Transaction::Status[1]
    else
      person = Person.find(options[:person_id])
      if person.balance > 0.0
        link_to "Receive payment", payment_account_transactions_path(current_account, {parent_id: options[:parent_id], person_id: options[:person_id]})
      else
        link_to "Create invoice", invoice_account_transactions_path(current_account, {person_id: person.id})
      end
    end
  end

  def purchases_action(status, options={})
    case status
    when Transaction::Status[0] || Transaction::Status[2]
      link_to "Pay order", payment_purchase_account_transactions_path(current_account, {parent_id: options[:parent_id], person_id: options[:person_id]})
    when Transaction::Status[3]
      link_to "Preview", preview_account_transaction_path(current_account, options[:parent_id])
    when Transaction::Status[1]
    else
      person = Person.find(options[:person_id])
      if person.balance > 0.0
        link_to "Pay order", payment_purchase_account_transactions_path(current_account, {parent_id: options[:parent_id], person_id: options[:person_id]})
      else
        link_to "Purchase order", purchase_account_transactions_path(current_account, {person_id: person.id})
      end
    end
  end

  def customer_id(params)
    if params[:parent_id].present?
      transaction = Transaction.find params[:parent_id]
      transaction.person.try :id
    elsif params[:person_id].present?
      person = Person.find params[:person_id]
      person.try :id
    else
      nil
    end
  end

end
