class ExpenseDatatable < TransactionDatatable

  private

  def get_raw_records
    options[:current_account].transactions.expenses.joins(:person)
  end

  def data
    records.map do |record|
      [
        format_date(record.transaction_date),
        record.transaction_type,
        record.transaction_number,
        record.person.try(:full_name),
        number_to_currency(record.total, unit: "PHP"),
        transaction_status(record.status),
        expenses_action(record)
      ]
    end
  end
end
