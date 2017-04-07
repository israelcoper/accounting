class HomeController < ApplicationController
  def index
    sales         = Transaction::Types[0]
    purchases     = Transaction::Types[2]
    last_30_days  = Date.parse(30.days.ago.strftime("%Y-%m-%d"))..Date.parse(Time.now.strftime("%Y-%m-%d"))
    last_60_days  = Date.parse(60.days.ago.strftime("%Y-%m-%d"))..Date.parse(31.days.ago.strftime("%Y-%m-%d"))
    last_90_days  = Date.parse(90.days.ago.strftime("%Y-%m-%d"))..Date.parse(61.days.ago.strftime("%Y-%m-%d"))
    over_90_days  = Date.parse(120.days.ago.strftime("%Y-%m-%d"))..Date.parse(91.days.ago.strftime("%Y-%m-%d"))

    @summary_sales = {
      overdue_last_30_days: current_account.transactions.overdue(sales, last_30_days),
      overdue_last_60_days: current_account.transactions.overdue(sales, last_60_days),
      overdue_last_90_days: current_account.transactions.overdue(sales, last_90_days),
      overdue_over_90_days: current_account.transactions.overdue(sales, over_90_days)
    }

    @summary_purchases = {
      overdue_last_30_days: current_account.transactions.overdue(purchases, last_30_days),
      overdue_last_60_days: current_account.transactions.overdue(purchases, last_60_days),
      overdue_last_90_days: current_account.transactions.overdue(purchases, last_90_days),
      overdue_over_90_days: current_account.transactions.overdue(purchases, over_90_days)
    }

    # FETCH EXPENSES OF THE CURRENT YEAR
    year  = Date.today.strftime("%Y").to_i      
    from  = Date.new(year)
    to    = Date.new(year, 12, 31)
    @summary_expenses = Item.yearly_expenses(current_account.id, from, to)

    # FETCH QUARTERLY SALES AND PURCHASES OF THE CURRENT YEAR
    q1 = Date.new(year, 1, 1)..Date.new(year, 03, 31)
    q2 = Date.new(year, 4, 1)..Date.new(year, 6, 30)
    q3 = Date.new(year, 7, 1)..Date.new(year, 9, 30)
    q4 = Date.new(year, 10, 1)..Date.new(year, 12, 31)

    @sales = current_account.transactions.sales
    @purchases = current_account.transactions.purchases 

    @quarterly_sales = [
      @sales.quarterly(q1).sum(:total).to_i,
      @sales.quarterly(q2).sum(:total).to_i,
      @sales.quarterly(q3).sum(:total).to_i,
      @sales.quarterly(q4).sum(:total).to_i
    ]

    @quarterly_purchases = [
      @purchases.quarterly(q1).sum(:total).to_i,
      @purchases.quarterly(q2).sum(:total).to_i,
      @purchases.quarterly(q3).sum(:total).to_i,
      @purchases.quarterly(q4).sum(:total).to_i
    ]

    # FETCH TODAY'S USERS ACTIVITIES
    @activities = current_account.activities.recent
  end
end
