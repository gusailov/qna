FactoryBot.define do
  factory :question do
    title { "Question title" }
    body { "Question text" }

    trait :invalid do
      title { nil }
    end
  end
end
