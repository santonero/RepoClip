FactoryBot.define do
  factory :comment do
    commenter { "A Guest User" }
    body { "This is a great comment!" }
    association :video
  end
end