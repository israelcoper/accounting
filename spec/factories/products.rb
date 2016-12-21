FactoryGirl.define do
  factory :product do
    association :account

    name { FFaker::Product.product_name }
    fields { Hash.new }

    factory :rice do
      product_type 0
      fields { {
        "average_kilo_per_sack" => 50,
        "number_of_sack" => 10,
        "number_of_kilo" => 500,
        "price_per_kilo" => 25
      } }
    end

    factory :invalid_product do
      name nil
    end
  end
end
