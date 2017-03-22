class TransactionsController < ApplicationController

  def show
    @transaction = Transaction.find params[:id]
    respond_to do |format|
      format.json { render json: @transaction }
    end
  end

  def sales
    type          = Transaction::Types[0]
    last_30_days  = 30.days.ago..Time.now
    last_60_days  = 60.days.ago..31.days.ago
    last_90_days  = 90.days.ago..61.days.ago
    over_90_days  = 120.days.ago..91.days.ago

    @transactions_summary = {
      overdue_last_30_days: current_account.transactions.overdue(type, last_30_days),
      overdue_last_60_days: current_account.transactions.overdue(type, last_60_days),
      overdue_last_90_days: current_account.transactions.overdue(type, last_90_days),
      overdue_over_90_days: current_account.transactions.overdue(type, over_90_days)
    }

    respond_to do |format|
      format.html
      format.json { render json: SalesDatatable.new(view_context, {current_account: current_account}) }
    end
  end

  def purchases
    type          = Transaction::Types[2]
    last_30_days  = 30.days.ago..Time.now
    last_60_days  = 60.days.ago..31.days.ago
    last_90_days  = 90.days.ago..61.days.ago
    over_90_days  = 120.days.ago..91.days.ago

     @transactions_summary = {
      overdue_last_30_days: current_account.transactions.overdue(type, last_30_days),
      overdue_last_60_days: current_account.transactions.overdue(type, last_60_days),
      overdue_last_90_days: current_account.transactions.overdue(type, last_90_days),
      overdue_over_90_days: current_account.transactions.overdue(type, over_90_days)
    }

    respond_to do |format|
      format.html
      format.json { render json: PurchaseDatatable.new(view_context, {current_account: current_account}) }
    end
  end

  def invoice
    @transaction = Transaction.new
    @customer = Person.new
    @product = Product.new
  end

  def purchase
    @transaction = Transaction.new
    @supplier = Person.new
    @product = Product.new
  end

  def create
    @transaction = Transaction.new transaction_params.merge(account: current_account)

    options = if @transaction.transaction_type == Transaction::Types[0]
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

    options = if @transaction.transaction_type == Transaction::Types[1]
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

  def preview
    @transaction = Transaction.find params[:id]
    render layout: "preview"
  end

  def children
    @transaction = Transaction.find params[:id]
    render json: @transaction.children
  end

  protected

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :transaction_date, :due_date, :notes, :payment, :balance, :total, :person_id, :parent_id, :payment_method,
                                        items_attributes: [:id, :product_id, :name, :description, :quantity, :rate, :amount, :_destroy]
    )
  end

end
