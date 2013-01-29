require 'factory_girl'

FactoryGirl.define do
  factory :form do
    sequence(:title) {|n| "Form #{n}"}
  end
end
