module SystemSpecHelpers
  def login_as(user)
    visit videos_path
    click_link "Log In"
    within "turbo-frame#add" do
      fill_in "account", with: user.username
      fill_in "password", with: "Password123!"
    end
    click_button "slogin"
    expect(page).to have_content("Logged in successfully.")
  end
end

RSpec.configure do |config|
  config.include SystemSpecHelpers, type: :system
end