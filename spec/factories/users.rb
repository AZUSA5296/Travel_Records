FactoryBot.define do

  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    nickname { Faker::Lorem.characters(number: 10) }
    birthday { '1990-01-01' }
    email { Faker::Internet.email }
    profile_image { File.open("#{Rails.root}/app/assets/images/image1.jpg") }
    introduction { Faker::Lorem.characters(number: 50) }
    password { 'password' }
    password_confirmation { 'password' }

    factory :other_user do
      name { Faker::Lorem.characters(number: 10) }
      nickname { Faker::Lorem.characters(number: 10) }
      birthday { '2000-01-01' }
      email { Faker::Internet.email }
      profile_image { File.open("#{Rails.root}/app/assets/images/image1.jpg") }
      introduction { Faker::Lorem.characters(number: 50) }
      password { 'password' }
      password_confirmation { 'password' }
    end

    factory :other_user2 do
      name { Faker::Lorem.characters(number: 10) }
      nickname { Faker::Lorem.characters(number: 10) }
      birthday { '1995-01-01' }
      email { Faker::Internet.email }
      profile_image { File.open("#{Rails.root}/app/assets/images/image1.jpg") }
      introduction { Faker::Lorem.characters(number: 50) }
      password { 'password' }
      password_confirmation { 'password' }
    end
  end

end