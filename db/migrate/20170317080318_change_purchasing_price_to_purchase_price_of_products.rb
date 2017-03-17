class ChangePurchasingPriceToPurchasePriceOfProducts < ActiveRecord::Migration
  def change
    rename_column :products, :purchasing_price, :purchase_price
  end
end
