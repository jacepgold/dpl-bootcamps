FactoryBot.define do
  sequence :email do |n|
    "test_#{n}@test.com"
  end

  factory :user do
    email
    password 'password'
    name 'Test User'
    nickname 'Test Testerson'
    application_ids []
  end
end