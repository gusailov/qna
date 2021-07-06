FactoryBot.define do
  factory :answer do
    body { "Answer text" }
    question

    trait :invalid do
      body { nil }
    end

    trait :attached do
      files { [Rack::Test::UploadedFile.new('spec/fixtures/files/image.jpg', 'image/jpg')] }
    end
  end
end
