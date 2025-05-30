require 'rails_helper'

RSpec.describe "Searching a video by title", type: :system, js: true do
  let!(:video1) { create(:video) }
  let!(:video2) { create(:video) }
  before { visit videos_path }
  scenario "displays links of corresponding videos when results are found" do
    within "form[action='/search'][method='get']" do
      fill_in "query", with: video1.title
      find("button.searchbtn").click
    end
    expect(page).to have_selector("div.card div.card-image a[href='/videos/#{video1.id}']")
    expect(page).not_to have_selector("div.card div.card-image a[href='/videos/#{video2.id}']")
    expect(page.current_path).to eq("/search")
    expect(page.current_url).to include("query=#{CGI.escape(video1.title)}")
  end

  scenario "displays a 'Nothing Found' page when no results are found" do
    within "form[action='/search'][method='get']" do
      fill_in "query", with: "Not An Existing Video"
      find("button.searchbtn").click
    end
    within "div.container div.empty" do
      within "div.empty-icon" do
        expect(page).to have_selector("svg#smily")
      end
      expect(page).to have_content("Sorry, we couldn't find any results.")
      expect(page).to have_content("Try another search?")
      within "form[action='/search'][method='get']" do
        expect(page).to have_selector("input#query2[name='query']")
        expect(page).to have_selector("button.searchbtn")
      end
    end
  end
end