FactoryGirl.define do
  factory :product do
    association :account

    name { FFaker::Product.product_name }
    description "Some description"
    quantity "0"
    purchase_price "0.0"
    selling_price "0.0"
    unit "kilo"
    product_number "1001"

    factory :inventory_product do
      category 0
    end

    factory :non_inventory_product do
      category 1
      unit "none"
    end

    factory :invalid_product do
      name nil
    end
  end
end
