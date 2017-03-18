class AddCreditTermsAndCreditLimitToPersons < ActiveRecord::Migration
  def change
    add_column :persons, :credit_terms, :integer, null: false, default: 0
    add_column :persons, :credit_limit, :decimal, null: false, default: 0.0, precision: 6, scale: 2
  end
end
