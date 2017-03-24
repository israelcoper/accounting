class CustomerTransactionsDatatable < TransactionDatatable

  private

  def get_raw_records
    options[:customer].transactions.sales.joins(:person)
  end

  def data
    records.map do |record|
      [
        format_date(record.transaction_date),
        record.transaction_type,
        transaction_link(record),
        format_date(record.due_date),
        number_to_currency(record.total, unit: "PHP"),
        number_to_currency(record.balance, unit: "PHP"),
        transaction_status(record.status),
        sales_action(record)
      ]
    end
  end
end
