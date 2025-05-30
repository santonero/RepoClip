require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { should have_secure_password }

  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).allow_blank }
    it { should validate_length_of(:username).is_at_most(18) }

    it { should validate_presence_of(:password).on(:password_update) }
    it { should validate_presence_of(:password_confirmation).on(:password_update) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should allow_value("Password123!").for(:password) }
    it { should_not allow_value("password", "PASSWORD", "12345678", "Password123", "password!1", "PASSWORD!1", "PasswordABC!").for(:password).with_message("must include at least one lowercase letter, one uppercase letter, one digit, and one special character") }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).allow_blank.ignoring_case_sensitivity }
    it { should validate_length_of(:email).is_at_most(42) }
    it { should allow_value("user@example.com", "another.user@sub.example.co.uk").for(:email) }
    it { should_not allow_value("user", "user@.com", "@example.com", "user @example.com", "user@ example.com", "user@domain..com" ).for(:email).with_message("must be a valid adress") }
  end

  describe "normalizations" do
    it { should normalize(:email).from(" ME@XYZ.COM\n").to("me@xyz.com")}
    it { should normalize(:username).from("  me\n").to("me") }
  end

  describe "token generation capabilities for password_reset" do
    let(:user) { create(:user) }

    it "responds to generate_token_for" do
      expect(user).to respond_to(:generate_token_for)
    end

    it "generates a non-blank token for :password_reset" do
      token = user.generate_token_for(:password_reset)
      expect(token).to be_a(String)
      expect(token).not_to be_blank
    end

    it "responds to the class method find_by_token_for" do
      expect(User).to respond_to(:find_by_token_for)
    end

    it "allows finding a user by a valid, fresh token for :password_reset" do
      token = user.generate_token_for(:password_reset)
      expect(User.find_by_token_for(:password_reset, token)).to eq(user)
    end

    it "does not find a user with an invalid token string for :password_reset" do
      expect(User.find_by_token_for(:password_reset, "this-is-not-a-valid-token")).to be_nil
    end
  end
end
