require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /session/new (new)" do
    before { get new_session_path }

    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renders the new session form within turbo_frame identified as 'add'" do
      assert_select "turbo-frame#add" do
        assert_select "form[action=?][method=?]", session_path, "post" do
          assert_select "input[name=?]", "account"
          assert_select "input[type=?][name=?]", "password", "password"
          assert_select "a", "Forgot your password?"
        end
      end
    end
  end

  describe "POST /session (create)" do
    let!(:user) { create(:user, username: "User", email: "user@email.com", password: "Password123!", password_confirmation: "Password123!") }
    context "with valid credentials" do
      let(:valid_credentials) { { account: "User", password: "Password123!" } }
      before { post session_path, params: valid_credentials, as: :turbo_stream }

      it "logs in the user" do
        expect(User.find_by!(id: session[:user_id])).to eq(User.find_by!(username: valid_credentials[:account]))
      end

      it "returns a turbo_stream response with a 'refresh' action" do
        expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
        assert_select "turbo-stream[action='refresh'][target='']", count: 1
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq("<i class='icon icon-check mx-1'></i> Logged in successfully.")
      end
    end

    context "with invalid credentials" do
      let(:invalid_credentials) { { account: "An Invalid User", password: "AnInval1dPass%" } }
      before { post session_path, params: invalid_credentials, as: :turbo_stream }

      it "returns an unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the form within the 'add' turbo_frame with errors" do
        assert_select "turbo-frame#add" do
          assert_select "form[action=?][method=?]", session_path, "post" do
            assert_select "input[name=?]", "account"
            assert_select "input[type=?][name=?]", "password", "password"
            assert_select "div.has-error"
            assert_select "span.top"
          end
        end
      end

      it "does not set a success flash message" do
        expect(flash[:notice]).to be_nil
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe "DELETE /session (destroy)" do
    let!(:current_user) { create(:user) }
    around { |example| Current.set(user: current_user) { example.run } }
    before { delete session_path, as: :turbo_stream }

    it "logs out the user" do
      expect(Current.user).to be_nil
    end

    it "returns a turbo_stream response with a 'refresh' action" do
      expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
      assert_select "turbo-stream[action='refresh'][target='']"
    end

    it "sets a success flash message" do
      expect(flash[:notice]).to eq("Logged out.")
    end
  end
end
