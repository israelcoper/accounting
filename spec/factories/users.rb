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
      role { User::Role.fetch(0) }
    end

    factory :accountant do
      role { User::Role.fetch(1) }
    end

    factory :normal do
      role { User::Role.fetch(2) }
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
