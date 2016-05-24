FactoryGirl.define do
  sequence :title do |n|
    "MyTitle#{n}"
  end

  factory :question do
    title
    body "MyBody"
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end

end
