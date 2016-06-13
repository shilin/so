FactoryGirl.define do
  sequence :title do |n|
    "MyQuestionTitle#{n}"
  end

  factory :question do
    title
    body 'MyQuestionBody'
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
