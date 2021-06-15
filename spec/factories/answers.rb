FactoryBot.define do
  factory :answer do
    body { "Answer text" }

    trait :invalid do
      body { nil }
    end
  end
end
