class EmployeeTransactionsDatatable < TransactionDatatable

  private

  def get_raw_records
    options[:employee].transactions.expenses.joins(:person)
  end

  def data
    records.map do |record|
      [
        format_date(record.transaction_date),
        record.transaction_number,
        number_to_currency(record.total, unit: "PHP"),
        transaction_status(record.status),
        expenses_action(record)
      ]
    end
  end
end
