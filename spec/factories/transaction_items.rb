FactoryGirl.define do
  factory :transaction_item do
    association :negotiation, factory: :transaction

    name { FFaker::Product.product_name }
    description "Product description"
    quantity 10
    rate 15.00
    amount 150.00
  end
end
