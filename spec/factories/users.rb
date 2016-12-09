FactoryGirl.define do
  sequence(:username) { |n| "username#{n}" }

  factory :user do
    association :account

    username { generate :username }
    password "secret"
    password_confirmation "secret"
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }

    factory :admin do
      role 2
    end

    factory :accountant do
      role 1
    end

    factory :normal do
      role 0
    end

    factory :invalid_user do
      username nil
      password nil
      password_confirmation nil
      first_name nil
      last_name nil
    end
  end

end
