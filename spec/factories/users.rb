FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    password '12345678'
    email
  end

  factory :author, class: User do
    password '12345678'
    email 'author@test.com'
  end

end
