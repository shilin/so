FactoryGirl.define do
  factory :answer do
    body "MyAnswerBody"
    question nil
  end

  factory :invalid_answer, class: Answer do
    body nil
    question nil
  end
end
