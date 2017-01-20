class TransactionsController < ApplicationController

  def show
    @transaction = Transaction.find params[:id]
    respond_to do |format|
      format.json { render json: @transaction }
    end
  end

  def sales
    @sales = current_account.transactions.sales.page(page)
  end

  def purchases
    @purchases = current_account.transactions.purchases.page(page)
  end

  def invoice
    @transaction = Transaction.new
  end

  def purchase
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new transaction_params.merge(account: current_account)

    options = if @transaction.transaction_type == Transaction::TransactionTypes[0]
                { render: :invoice, redirect: sales_account_transactions_path(current_account) }
              else
                { render: :purchase, redirect: purchases_account_transactions_path(current_account) }
              end

    unless @transaction.items.present?
      flash[:error] = "You must select an item"
      render options[:render] and return
    end

    if @transaction.save
      @transaction.add_balance_to_person
      flash[:notice] = "Transaction was successfully created"
      redirect_to options[:redirect]
    else
      render options[:render]
    end
  end

  def payment
    @transaction = Transaction.new
  end

  def payment_purchase
    @transaction = Transaction.new
  end

  def payment_receive
    @transaction = Transaction.new transaction_params.merge(account: current_account)

    options = if @transaction.transaction_type == Transaction::TransactionTypes[1]
                { render: :payment, redirect: sales_account_transactions_path(current_account) }
              else
                { render: :payment_purchase, redirect: purchases_account_transactions_path(current_account) }
              end

    if @transaction.payment.blank? || !(@transaction.payment > 0)
      flash[:error] = "You must select an invoice number and enter payment amount"
      render options[:render] and return
    end

    if @transaction.save
      @transaction.deduct_balance_of_person
      flash[:notice] = "Payment was successfull created"
      redirect_to options[:redirect]
    else
      render options[:render]
    end
  end

  protected

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :transaction_date, :due_date, :notes, :payment, :balance, :total, :person_id, :parent_id,
                                        items_attributes: [:id, :product_id, :name, :description, :quantity, :rate, :amount, :_destroy]
    )
  end

  # default product type
  def transaction_product_type
    params[:product_type].present? ? params[:product_type] : "rice"
  end
  helper_method :transaction_product_type

end
