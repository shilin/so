# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    body 'MyCommentText'
    user
  end

  factory :invalid_comment, class: Comment do
    body nil
    user
  end
end
