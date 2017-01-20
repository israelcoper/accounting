FactoryGirl.define do
  factory :product do
    association :account

    name { FFaker::Product.product_name }
    description "Some description"
    cost "100"
    fields { Hash.new }

    factory :rice do
      product_type "rice"
      fields { {
        "average_kilo_per_sack" => "50",
        "number_of_sack" => "10",
        "number_of_kilo" => "500",
        "purchasing_price" => "20",
        "selling_price" => "25"
      } }
    end

    factory :grocery_item do
      product_type "grocery_item"
      fields { {
        "purchasing_price" => "10",
        "selling_price" => "15",
        "quantity" => "50"
      } }
    end

    factory :invalid_product do
      name nil
    end
  end
end
