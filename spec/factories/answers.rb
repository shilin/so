FactoryGirl.define do
  factory :answer do
    body "MyBody"
    question nil
  end

  factory :invalid_answer, class: Answer do
    body nil
    question nil
  end
end
