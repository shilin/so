FactoryGirl.define do
  sequence :body do |n|
    "MyAnswerBody#{n}"
  end

  factory :answer do
    body
    question
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
  end
end
