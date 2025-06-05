require 'rails_helper'

RSpec.describe "Destroying a video", type: :system, js: true do
  let!(:video) { create(:video) }

  before do
    visit video_path(video)
    expect(page).to have_content(video.title)
  end

  scenario "successfully when user confirms deletion" do
    expect do
      accept_confirm { find("button[type='submit'][data-tooltip='Delete Video']").click }
      expect(page).to have_current_path(root_path)
    end.to change(Video, :count).by(-1)

    expect(page).to have_content("Video was successfully destroyed.")
    expect(page).not_to have_content(video.title)
  end

  scenario "fails when user dismisses confirmation" do
    expect do
      dismiss_confirm { find("button[type='submit'][data-tooltip='Delete Video']").click }
    end.not_to change(Video, :count)

    expect(page).to have_current_path(video_path(video))
    expect(page).to have_content(video.title)
    expect(page).not_to have_content("Video was successfully destroyed.")
  end
end