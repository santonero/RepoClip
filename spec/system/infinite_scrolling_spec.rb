require 'rails_helper'

RSpec.describe "Infinite Scrolling", type: :system, js: true do
  let!(:videos) do
    (1..20).map { create(:video) }
  end

  scenario "loads more videos when scrolling down" do
    oldest_video_on_second_page = videos.first
    visit videos_path
    within "div#grid" do
      expect(page).not_to have_selector("a.card-footer", text: oldest_video_on_second_page.title, exact_text: true)
      expect(page).not_to have_selector("div.card div.card-image a[href='/videos/#{videos[0].id}']")
      expect(page).not_to have_selector("div.card div.card-image a[href='/videos/#{videos[1].id}']")
      expect(page).not_to have_selector("div.card div.card-image a[href='/videos/#{videos[2].id}']")
      expect(page).to have_selector("div.card div.card-image a[href='/videos/#{videos[3].id}']")
      expect(page).to have_selector("div.card div.card-image a", count: 17)
    end
    attempts = 0
    max_scroll_attempts = 10

    until page.has_selector?("a.card-footer", text: oldest_video_on_second_page.title, exact_text: true, wait: 0.2) || attempts >= max_scroll_attempts
      page.execute_script("window.scrollBy(0, 300);")
      attempts += 1
    end

    within "div#grid" do
      expect(page).to have_selector("a.card-footer", text: oldest_video_on_second_page.title, exact_text: true)
      expect(page).to have_selector("div.card div.card-image a[href='/videos/#{videos[0].id}']")
      expect(page).to have_selector("div.card div.card-image a[href='/videos/#{videos[1].id}']")
      expect(page).to have_selector("div.card div.card-image a[href='/videos/#{videos[2].id}']")
      expect(page).to have_selector("div.card div.card-image a[href='/videos/#{videos[3].id}']")
      expect(page).to have_selector("div.card div.card-image a", count: 20)
    end
  end
end