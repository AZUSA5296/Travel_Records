FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 10) }
    date { '2020-01-01' }
    image  { File.open("#{Rails.root}/app/assets/images/image1.jpg") }
    content { Faker::Lorem.characters(number: 50) }
    user
  end
end