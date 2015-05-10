require 'faker'

FactoryGirl.define do
  fake_password = 'password'
  factory :user do
    first_name            { Faker::Name.first_name }
    middle_name           { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    sequence(:username)   {|n| [first_name, n].join }
    sequence(:email)      {|n| [first_name, middle_name, n, '@', last_name, '.com'].join }
    password              fake_password
    password_confirmation fake_password

    trait :admin do
      admin true
    end
  end
end