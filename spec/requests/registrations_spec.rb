require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /registration/new (new)" do
    before { get new_registration_path }

    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renders the new registration form" do
      assert_select "form[action=?][method=?]", registration_path, "post" do
        assert_select "input[name=?]", "user[username]"
        assert_select "input[type=?][name=?]", "email", "user[email]"
        assert_select "input[type=?][name=?]", "password", "user[password]"
        assert_select "input[type=?][name=?]", "password", "user[password_confirmation]"
        assert_select "input[type=?][name=?][value=?]", "submit", "commit", "Sign Up"
      end
    end
  end

  describe "POST /registration (create)" do
    context "with valid parameters" do
      let(:valid_parameters) do
        {
          user: {
            username: "Username",
            email: "username@email.com",
            password: "Password123!",
            password_confirmation: "Password123!"
          }
        }
      end

      it "registers a new account and logs in the new user" do
        expect { post registration_path, params: valid_parameters, as: :turbo_stream }.to change(User, :count).by(1)
        expect(User.find_by!(id: session[:user_id])).to eq(User.find_by!(username: valid_parameters[:user][:username]))
      end

      it "redirects to root url in HTML and sets a success flash message" do
        post registration_path, params: valid_parameters, as: :turbo_stream
        expect(response).to redirect_to(root_url(format: :html))
        expect(flash[:notice]).to eq("<i class='icon icon-check mx-1'></i> Account successfully created.")
      end
    end

    context "with invalid parameters" do
      let(:invalid_parameters) do
        {
          user: {
            username: "",
            email: "foo@bar.com",
            password: "123",
            password_confirmation: "123"
          }
        }
      end

      it "does not register a new account" do
        expect { post registration_path, params: invalid_parameters, as: :turbo_stream }.not_to change(User, :count)
      end

      context "response for failed registration" do
        before { post registration_path, params: invalid_parameters, as: :turbo_stream }

        it "returns an unprocessable_entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "re-renders the form with errors" do
          assert_select "form[action=?][method=?]", registration_path, "post" do
            assert_select "input[name=?][value=?]", "user[username]", invalid_parameters[:user][:username]
            assert_select "input[type=?][name=?][value=?]", "email", "user[email]", invalid_parameters[:user][:email]
            assert_select "input[type=?][name=?]", "password", "user[password]"
            assert_select "input[type=?][name=?]", "password", "user[password_confirmation]"
            assert_select "input[type=?][name=?][value=?]", "submit", "commit", "Sign Up"
            assert_select "div.has-error"
            assert_select "p.form-input-hint", "Username can't be blank"
            assert_select "p.form-input-hint", "Password is too short (minimum is 8 characters)"
          end
        end

        it "does not set a success flash message" do
          expect(flash[:notice]).to be_nil
          expect(flash[:success]).to be_nil
        end
      end
    end
  end
end
