require 'rails_helper'

RSpec.describe "Viewing a video", type: :system, js: true do
  let!(:video) { create(:video, title: "Amazing Title to View", description: "A very detailed description to check.") }
  let!(:comment1) { create(:comment, video: video, commenter: "User1", body: "First comment!") }
  let!(:comment2) { create(:comment, video: video, commenter: "User2", body: "Second comment, newer!", created_at: 1.hour.from_now) }

  scenario "user views a video's details and comments" do
    visit videos_path
    find("div.card div.card-image a[href='#{video_path(video)}']").click
    expect(page).to have_current_path(video_path(video), ignore_query: true)

    expect(page).to have_selector("media-player")
    within "div#vidfoot" do
      expect(page).to have_content(video.title)
      expect(page).to have_content(video.created_at.strftime("%b %d, %Y"))
      expect(page).to have_content(video.description)
    end

    within "div#comments" do
      expect(page).to have_selector("div#comment_#{comment1.id}")
      expect(page).to have_selector("div#comment_#{comment2.id}")
      expect(page).to have_content("User1")
      expect(page).to have_content("First comment!")
      expect(page).to have_content("User2")
      expect(page).to have_content("Second comment, newer!")

      all_comments_div = page.all("div[id^='comment_']")
      if all_comments_div.size == 2
        expect(all_comments_div[0][:id]).to eq("comment_#{comment2.id}")
        expect(all_comments_div[1][:id]).to eq("comment_#{comment1.id}")
      end
    end

    within "turbo-frame#new_comment" do
      expect(page).to have_field("comment_commenter")
      expect(page).to have_field("comment_body")
    end
  end
end