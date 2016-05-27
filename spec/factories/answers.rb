FactoryGirl.define do
  factory :answer do
    body "MyAnswerBody"
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
