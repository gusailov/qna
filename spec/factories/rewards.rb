FactoryBot.define do
  factory :reward do
    title { "Reward title" }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/image.jpg', 'image/jpg') }

    trait :invalid do
      title { nil }
    end
  end
end
