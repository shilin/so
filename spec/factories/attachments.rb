FactoryGirl.define do
  factory :attachment do
    file do
      File.open("#{Rails.root}/spec/rails_helper.rb")
    end
  end
end
