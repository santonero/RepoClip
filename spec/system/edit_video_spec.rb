require 'rails_helper'

RSpec.describe "Editing a video", type: :system, js: true do
  let!(:video) { create(:video, title: "Original Title", description: "Original Description") }

  before do
    visit video_path(video)
    find("button[name='button'][type='submit'][data-tooltip='Edit']").click
    expect(page).to have_selector("turbo-frame#add input[name='video[title]']")
  end

  scenario "successfully with valid changes" do
    within "turbo-frame#add" do
      expect(page).to have_field("video[title]", with: "Original Title")
      expect(page).to have_field("video[description]", with: "Original Description")

      fill_in "video[title]", with: "Updated Awesome Title"
      fill_in "video[description]", with: "This description has been updated by a system test."
    end

    click_button "svidform"

    expect(page).to have_content("Video was successfully updated.")
    expect(page).to have_current_path(video_path(video), ignore_query: true)
    within "div#vidfoot" do
      expect(page).to have_content("Updated Awesome Title")
      expect(page).to have_content("This description has been updated by a system test.")
    end
  end

  scenario "fails due to invalid changes" do
    within "turbo-frame#add" do
      fill_in "video[title]", with: ""
      fill_in "video[description]", with: "Attempting update with blank title."
    end

    click_button "svidform"

    within "turbo-frame#add" do
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_field("video[title]", with: "")
      expect(page).to have_field("video[description]", with: "Attempting update with blank title.")
      expect(page).to have_selector("div.has-error", count: 1)
    end
  end
end