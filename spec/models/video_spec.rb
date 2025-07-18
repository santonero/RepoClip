require 'rails_helper'

RSpec.describe Video, type: :model do
  subject { build(:video) }

  describe "associations" do
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).allow_blank }
    it { should validate_length_of(:title).is_at_most(30) }

    it { should validate_length_of(:description).is_at_most(550)}

    it { should validate_attached_of(:clip) }
    it {
      should validate_content_type_of(:clip)
        .allowing("video/mp4", "video/webm")
        .rejecting("image/png", "application/pdf")
    }
    it { should validate_size_of(:clip).less_than_or_equal_to(75.megabytes) }

    it { should validate_attached_of(:thumbnail) }
    it {
      should validate_content_type_of(:thumbnail)
        .allowing("image/png", "image/jpeg", "image/webp")
        .rejecting("video/mp4", "application/pdf")
    }
    it { should validate_size_of(:thumbnail).less_than_or_equal_to(2.megabytes) }
  end
end