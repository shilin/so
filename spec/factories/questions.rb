# frozen_string_literal: true
FactoryGirl.define do
  sequence :title do |n|
    "MyQuestionTitle#{n}"
  end

  factory :question do
    title
    body 'MyQuestionBody'
    user
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
    user
  end
end
