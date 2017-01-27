class SupplierTransactionsDatatable < TransactionDatatable

  private

  def get_raw_records
    options[:supplier].transactions.purchases.joins(:person)
  end

  def data
    records.map do |record|
      [
        format_date(record.transaction_date),
        record.transaction_type,
        record.transaction_number,
        format_date(record.due_date),
        number_to_currency(record.balance, unit: "PHP"),
        number_to_currency(record.total, unit: "PHP"),
        transaction_status(record.status),
        purchases_action(record.status, parent_id: record.id, person_id: record.person.id)
      ]
    end
  end
end
