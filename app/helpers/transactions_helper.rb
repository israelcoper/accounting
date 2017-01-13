module TransactionsHelper

  def format_date(date)
    return nil if date.nil?
    date.strftime "%m/%d/%Y"
  end

  def action_sales(status)
    return nil if status.nil?
    case status
    when Transaction::Status[0] || Transaction::Status[2]
      link_to "Receive payment", "javascript:;"
    when Transaction::Status[3]
      link_to "Print", "javascript:;"
    else
    end
  end

end
