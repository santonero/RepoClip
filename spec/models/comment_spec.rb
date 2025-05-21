require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:video) { create(:video) }
  subject { build(:comment, video: video) }

  describe "associations" do
    it { should belong_to(:video) }
  end

  describe "validations" do
    it { should validate_presence_of(:commenter) }
    it { should validate_length_of(:commenter).is_at_most(18) }

    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(2).is_at_most(300) }
  end

  describe "custom validation: name_availability" do
    let!(:existing_user) { create(:user, username: "TakenName") }

    context "when Current.user is not present (anonymous commenter)" do
      around { |example| Current.set(user: nil) { example.run } }

      it "is invalid if commenter name is taken by an existing user" do
        comment = build(:comment, video: video, commenter: "TakenName")
        comment.valid?
        expect(comment.errors[:commenter]).to include("has already been taken")
      end

      it "is valid if commenter name is not taken" do
        comment = build(:comment, video: video, commenter: "UniqueName")
        expect(comment).to be_valid
      end
    end

    context "when Current.user is present (logged-in commenter)" do
      let(:current_user) { create(:user, username: "LoggedInUser", email: "current@user.com") }

      around { |example| Current.set(user: :current_user) { example.run } }

      it "is valid when commenter is set to Current.user.username and name_availability does not run" do
        comment = build(:comment, video: video, commenter: current_user.username)
        expect(comment).to be_valid
      end
    end
  end

  describe "scopes" do
    describe "default_scope" do
      it "orders comments by created_at in descending order" do
        comment1 = create(:comment, video: video, created_at: 1.day.ago)
        comment2 = create(:comment, video: video, created_at: 2.day.ago)
        comment3 = create(:comment, video: video, created_at: Time.current)

        expect(video.comments.to_a).to eq([comment3, comment1, comment2])
      end
    end
  end
end
