# frozen_string_literal: true
FactoryGirl.define do
  factory :identity do
    user nil
    provider 'MyString'
    uid 'MyString'
  end
end
