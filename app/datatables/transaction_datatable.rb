class TransactionDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :format_date, :number_to_currency, :transaction_status, :sales_action, :purchases_action, :expenses_action, :transaction_link

  def sortable_columns
    @sortable_columns ||= [
      'Transaction.transaction_date',
      'Person.first_name'
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
      'Transaction.transaction_number',
      'Transaction.status',
      'Person.first_name',
      'Person.last_name'
    ]
  end
end
