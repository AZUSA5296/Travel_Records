FactoryBot.define do
  factory :comment do
    comment { Faker::Lorem.characters(number: 50) }
    user
    post
  end
end