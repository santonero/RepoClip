require 'rails_helper'

RSpec.describe "Sessions management", type: :system, js: true do
  let!(:user) { create(:user) }

  describe "Creating a new session" do
    scenario "successfully with valid credentials and stay on same page" do
      login_as(user)
      expect(page).to have_content(user.username)
      expect(page).to have_current_path(videos_path)
      expect(page).to have_selector("button[data-tooltip='Log Out']")
    end

    scenario "fails with invalid credentials" do
      visit videos_path
      click_link "Log In"
      within "turbo-frame#add" do
        fill_in "account", with: "InvalidAccount"
        fill_in "password", with: "InvalidPassword"
      end
      click_button "slogin"
      expect(page).to have_selector("div.has-error", count: 2)
      expect(page).to have_selector("span.top", count: 1)
      expect(page).not_to have_content(user.username)
      expect(page).not_to have_content("Logged in successfully.")
      expect(page).to have_current_path(videos_path)
      expect(page).to have_link("Log In")
      expect(page).not_to have_selector("button[data-tooltip='Log Out']")
    end
  end

  describe "Destroying current session" do
    scenario "successfully and stay on same page" do
      login_as(user)
      find("button[data-tooltip='Log Out']").click
      expect(page).to have_content("Logged out.")
      expect(page).to have_content("Log In")
      expect(page).to have_current_path(videos_path)
      expect(page).not_to have_selector("button[data-tooltip='Log Out']")
      expect(page).not_to have_content(user.username)
    end
  end
end
