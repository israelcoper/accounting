FactoryGirl.define do
  factory :person do
    association :account

    first_name { FFaker::Name.first_name }
    middle_name { FFaker::Name.last_name }
    last_name { FFaker::Name.last_name }
    phone { FFaker::PhoneNumber.phone_number }
    mobile { FFaker::PhoneNumberDE.mobile_phone_number }
    address { Hash.new }
    notes "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    credit_limit "100000"
    credit_terms "30"
    picture { Rack::Test::UploadedFile.new("spec/support/fixtures/image.png", 'image/png') }

    factory :customer do
      person_type 0
    end

    factory :supplier do
      person_type 1
    end

    factory :employee do
      person_type 2
    end

    factory :invalid_person do
      first_name nil
      last_name nil
      phone nil
    end
  end
end
