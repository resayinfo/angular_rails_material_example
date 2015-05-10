require 'faker'

FactoryGirl.define do
  factory :post do
    title { Faker::Company.bs.titleize }
    body { Faker::Lorem.paragraph }
    user { User.first }
  end
end