FactoryBot.define do
  factory :question do
    title { "Question title" }
    body { "Question text" }

    trait :invalid do
      title { nil }
    end

    trait :attached do
      files { [Rack::Test::UploadedFile.new('spec/fixtures/files/image.jpg', 'image/jpg')] }
    end
  end
end
