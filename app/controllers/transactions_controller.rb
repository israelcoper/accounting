class TransactionsController < ApplicationController

  def sales
    @sales = Transaction.sales
  end

  def invoice
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new transaction_params.merge(account: current_account)

    unless @transaction.items.present?
      flash[:error] = "You must select an item"
      render :invoice and return
    end

    if @transaction.save
      flash[:notice] = "Transaction was successfully created"
      redirect_to sales_account_transactions_path(current_account)
    else
      render :invoice
    end
  end

  protected

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :transaction_date, :due_date, :notes, :payment, :balance, :total, :person_id,
                                        items_attributes: [:id, :product_id, :name, :description, :quantity, :rate, :amount, :_destroy]
    )
  end

  # default product type
  def transaction_product_type
    params[:product_type].present? ? params[:product_type] : "rice"
  end
  helper_method :transaction_product_type

end
