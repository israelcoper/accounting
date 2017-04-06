class TransactionsController < ApplicationController
  before_action :find_transaction, only: [:show, :destroy, :preview, :children, :payment, :payment_purchase, :payment_receive]

  def show
    respond_to do |format|
      format.json { render json: @transaction }
    end
  end

  def destroy
    options = if Transaction::Types.values_at(0).include?(@transaction.transaction_type)
                { redirect: sales_account_transactions_path(current_account) }
              elsif Transaction::Types.values_at(2).include?(@transaction.transaction_type)
                { redirect: purchases_account_transactions_path(current_account) }
              else
                { redirect: expenses_account_transactions_path(current_account) }
              end

    @transaction.destroy
    @transaction.cancel_person_transaction!

    # Activity log
    current_user.activities.create(negotiation: @transaction, name: t('activity.cancel', transaction_number: @transaction.transaction_number))

    redirect_to options[:redirect], notice: "Transaction successfully cancelled"
  end

  def sales
    # TODO: REFACTOR
    type          = Transaction::Types[0]
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
    # TODO: REFACTOR
    type          = Transaction::Types[2]
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

  def expenses
    respond_to do |format|
      format.html
      format.json { render json: ExpenseDatatable.new(view_context, {current_account: current_account}) }
    end
  end

  def invoice
    @transaction = current_account.transactions.build
    @customer = Person.new
    @product = Product.new
  end

  def purchase
    @transaction = current_account.transactions.build
    @supplier = Person.new
    @product = Product.new
  end

  def expense
    @transaction = current_account.transactions.build
    @employee = Person.new
    @product = Product.new
  end

  def create
    @transaction = current_account.transactions.build(transaction_params)
    @customer = Person.new
    @product = Product.new

    options = if Transaction::Types.values_at(0).include?(@transaction.transaction_type)
                { render: :invoice, redirect: sales_account_transactions_path(current_account), text: "quantity" }
              elsif Transaction::Types.values_at(2).include?(@transaction.transaction_type)
                { render: :purchase, redirect: purchases_account_transactions_path(current_account), text: "quantity" }
              else
                { render: :expense, redirect: expenses_account_transactions_path(current_account), text: "amount" }
              end

    unless @transaction.items.present?
      flash[:error] = "You must select an item and enter #{options[:text]}"
      render options[:render] and return
    end

    if @transaction.save
      @transaction.add_balance_to_person

      # Activity log
      activity = case @transaction.transaction_type
                 when Transaction::Types[0]
                   t('activity.invoice', transaction_number: @transaction.transaction_number)
                 when Transaction::Types[2]
                   t('activity.purchase', transaction_number: @transaction.transaction_number)
                 else
                   t('activity.expense', transaction_number: @transaction.transaction_number)
                 end
      current_user.activities.create(negotiation: @transaction, name: activity)

      flash[:notice] = "Transaction was successfully created"
      redirect_to options[:redirect]
    else
      render options[:render]
    end
  end

  def payment
    @child_transaction = @transaction.children.build
  end

  def payment_purchase
    @child_transaction = @transaction.children.build
  end

  def payment_receive
    @child_transaction = @transaction.children.build(transaction_params.merge(account: current_account))

    options = if Transaction::Types.values_at(1).include?(@child_transaction.transaction_type)
                { render: :payment, redirect: sales_account_transactions_path(current_account) }
              else
                { render: :payment_purchase, redirect: purchases_account_transactions_path(current_account) }
              end

    if @child_transaction.payment.blank? || !(@child_transaction.payment > 0)
      flash[:error] = "You must select an invoice number and enter payment amount"
      render options[:render] and return
    end

    if @child_transaction.save
      @child_transaction.deduct_balance_of_person

      # Activity log
      activity = if @child_transaction.transaction_type.eql?(Transaction::Types[1])
                   t('activity.payment', transaction_number: @transaction.transaction_number)
                 else
                   t('activity.payment_purchase', transaction_number: @transaction.transaction_number)
                 end
      current_user.activities.create(negotiation: @transaction, name: activity)

      flash[:notice] = "Payment was successfull created"
      redirect_to options[:redirect]
    else
      render options[:render]
    end
  end

  def preview
    if Transaction::Types.values_at(0,2).include?(@transaction.transaction_type)
      render 'preview', layout: "preview"
    elsif Transaction::Types.values_at(1,3).include?(@transaction.transaction_type)
      render 'preview_payment', layout: "preview"
    else
      render 'preview_expense', layout: "preview"
    end
  end

  def children
    render json: @transaction.children
  end

  def overdue
    due_date = Date.parse(params[:start_date])..Date.parse(params[:end_date])
    @transactions = current_account.transactions.overdue(params[:type], due_date)
    render json: @transactions
  end

  protected

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :transaction_date, :due_date, :notes, :payment, :balance, :total, :person_id, :payment_method,
                                        items_attributes: [:id, :product_id, :name, :description, :quantity, :rate, :amount, :_destroy]
    )
  end

  def find_transaction
    @transaction ||= current_account.transactions.find(params[:id])
  end

end
