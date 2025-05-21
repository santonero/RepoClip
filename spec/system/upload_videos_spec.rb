require 'rails_helper'

RSpec.describe "Uploading a new video", type: :system, js: true do
  before { visit videos_path }

  scenario "successfully with valid data and files" do
    find("#new_video").click
    within "turbo-frame#add" do
      fill_in "video[title]", with: "My Awesome System Test Video"
      fill_in "video[description]", with: "This video was uploaded via a system test!"
      attach_file "video_clip", Rails.root.join("spec/fixtures/files/sample_video.mp4")
      attach_file "video_thumbnail", Rails.root.join("spec/fixtures/files/sample_thumbnail.png")
    end

    find("#svidform").click
    expect(page).to have_content("My Awesome System Test Video")
    expect(page).to have_current_path(video_path(Video.last), ignore_query: true)
    expect(page).to have_content("This video was uploaded via a system test!")
    expect(page).to have_content("Video was successfully created.")
  end

  scenario "fails with invalid data and files" do
    find("#new_video").click
    within "turbo-frame#add" do
      fill_in "video[title]", with: ""
      attach_file "video_clip", Rails.root.join("spec/fixtures/files/sample_thumbnail.png")
      attach_file "video_thumbnail", Rails.root.join("spec/fixtures/files/sample_video.mp4")
    end

    expect do
      find("#svidform").click
      expect(page).to have_content("Title can't be blank")
    end.to_not change(Video, :count)

    within "turbo-frame#add" do
      expect(page).to have_content("Video has an invalid content type")
      expect(page).to have_content("Thumbnail has an invalid content type")
    end
    expect(page).to have_current_path(videos_path, ignore_query: true)
  end
end