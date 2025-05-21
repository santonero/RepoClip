FactoryBot.define do
  factory :video do
    sequence(:title) { |n| "Sample Video Title#{n}" }
    description { "A great sample video description." }
    clip { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/sample_video.mp4"), "video/mp4") }
    thumbnail { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/sample_thumbnail.png"), "image/png") }
  end
end