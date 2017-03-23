class TransactionsController < ApplicationController

  def show
    @transaction = Transaction.find params[:id]
    respond_to do |format|
      format.json { render json: @transaction }
    end
  end

  def sales
    type          = Transaction::Types[0]
    # TODO: REFACTOR
    last_30_days  = Date.parse(30.days.ago.strftime("%Y-%m-%d"))..Date.parse(Time.now.strftime("%Y-%m-%d"))
    last_60_days  = Date.parse(60.days.ago.strftime("%Y-%m-%d"))..Date.parse(31.days.ago.strftime("%Y-%m-%d"))
    last_90_days  = Date.parse(90.days.ago.strftime("%Y-%m-%d"))..Date.parse(61.days.ago.strftime("%Y-%m-%d"))
    over_90_days  = Date.parse(120.days.ago.strftime("%Y-%m-%d"))..Date.parse(91.days.ago.strftime("%Y-%m-%d"))

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
    # TODO: REFACTOR
    last_30_days  = Date.parse(30.days.ago.strftime("%Y-%m-%d"))..Date.parse(Time.now.strftime("%Y-%m-%d"))
    last_60_days  = Date.parse(60.days.ago.strftime("%Y-%m-%d"))..Date.parse(31.days.ago.strftime("%Y-%m-%d"))
    last_90_days  = Date.parse(90.days.ago.strftime("%Y-%m-%d"))..Date.parse(61.days.ago.strftime("%Y-%m-%d"))
    over_90_days  = Date.parse(120.days.ago.strftime("%Y-%m-%d"))..Date.parse(91.days.ago.strftime("%Y-%m-%d"))

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
    @customer = Person.new
    @product = Product.new

    options = if @transaction.transaction_type == Transaction::Types[0]
                { render: :invoice, redirect: sales_account_transactions_path(current_account) }
              else
                { render: :purchase, redirect: purchases_account_transactions_path(current_account) }
              end

    unless @transaction.items.present?
      flash[:error] = "You must select an item and enter quantity"
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

  def overdue
    due_date = Date.parse(params[:start_date])..Date.parse(params[:end_date])
    @transactions = current_account.transactions.overdue(params[:type], due_date)
    render json: @transactions
  end

  protected

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :transaction_date, :due_date, :notes, :payment, :balance, :total, :person_id, :parent_id, :payment_method,
                                        items_attributes: [:id, :product_id, :name, :description, :quantity, :rate, :amount, :_destroy]
    )
  end

end
