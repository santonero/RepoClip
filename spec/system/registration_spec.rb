require 'rails_helper'

RSpec.describe "Registering", type: :system, js: true do
  before { visit new_registration_path }

  scenario "successfully with valid data" do
    within "form[action='#{registration_path}'][method='post']" do
      fill_in "user[username]", with: "Username123"
      fill_in "user[email]", with: "user@email.com"
      fill_in "user[password]", with: "Password123!"
      fill_in "user[password_confirmation]", with: "Password123!"
      click_on "Sign Up"
    end
    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_content("Account successfully created.")
    expect(page).to have_content("Username123")
    expect(page).to have_selector("button[data-tooltip='Log Out']")
  end

  scenario "fails with invalid data" do
    expect do
      within "form[action='#{registration_path}'][method='post']" do
        fill_in "user[username]", with: ""
        fill_in "user[email]", with: "user@email.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "wordpass"
        click_on "Sign Up"
      end
    end.not_to change(User, :count)
    within "form[action='#{registration_path}'][method='post']" do
      expect(page).to have_selector("div.has-error", count: 3)
      expect(page).to have_content("Username can't be blank")
      expect(page).to have_content("Password must include at least one lowercase letter, one uppercase letter, one digit, and one special character")
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
    expect(page).to have_current_path(new_registration_path)
    expect(page).not_to have_content("Account successfully created.")
  end
end