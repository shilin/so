# frozen_string_literal: true
FactoryGirl.define do
  factory :attachment do
    file do
      File.open("#{Rails.root}/spec/rails_helper.rb")
    end
  end
end
