class IncreasePrecisionOfCreditLimitofPersons < ActiveRecord::Migration
  def change
    change_column :persons, :credit_limit, :decimal, default: 0.0, precision: 16, scale: 2
  end
end
