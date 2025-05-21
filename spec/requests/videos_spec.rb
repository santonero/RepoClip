require 'rails_helper'

RSpec.describe "Videos", type: :request do
  let!(:video1) { create(:video) }
  let!(:video2) { create(:video) }

  describe "GET /videos (index)" do
    before { get videos_path }
    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "displays the hero section title" do
      expect(response.body).to include("<h1>Share Your Clips, Simply.</h1>")
    end

    it "displays all video titles" do
      expect(response.body).to include(video1.title)
      expect(response.body).to include(video2.title)
    end
  end

  describe "GET /videos/:id (show)" do
    context "when the video exist" do
      before { get video_path(video1) }

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "displays a video player" do
        assert_select "media-player"
      end

      it "displays the video title" do
        expect(response.body).to include(video1.title)
      end

      it "displays the video description" do
        expect(response.body).to include(video1.description)
      end
    end

    context "when the video does not exist" do
      before { get video_path(id: "non-existent-id") }

      it "redirects to the root url" do
        expect(response).to redirect_to(root_url)
      end

      it "sets an alert message" do
        expect(flash[:alert]).to eq("Video does not exist.")
      end

      it "returns a redirect status" do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "GET /videos/new (new)" do
    before { get new_video_path }

    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renders the new video form within a turbo_frame identified as 'add'" do
      assert_select "turbo-frame#add" do
        assert_select "form[action=?][method=?]", videos_path, "post" do
          assert_select "input[name=?]", "video[title]"
          assert_select "input[type=?][name=?]", "file", "video[clip]"
          assert_select "input[type=?][name=?]", "file", "video[thumbnail]"
          assert_select "textarea[name=?]", "video[description]"
        end
      end
    end
  end

  describe "POST /videos (create)" do
    let(:valid_clip_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/sample_video.mp4"), "video/mp4") }
    let(:valid_thumbnail_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/sample_thumbnail.png"), "image/png") }

    context "with valid parameters" do
      let(:valid_video_params) do
        {
          video: {
            title: "My New Awesome Video",
            description: "A great description for this new video.",
            clip: valid_clip_file,
            thumbnail: valid_thumbnail_file
          }
        }
      end

      it "creates a new Video with the correct attributes when TURBO_STREAM is requested" do
        expect {
          post videos_path, params: valid_video_params, as: :turbo_stream
        }.to change(Video, :count).by(1)

        created_video = Video.find_by!(title: valid_video_params[:video][:title])
        expect(created_video.description).to eq(valid_video_params[:video][:description])
        expect(created_video.clip).to be_attached
        expect(created_video.thumbnail).to be_attached
      end

      context "response when TURBO_STREAM is requested" do
        before { post videos_path, params: valid_video_params, as: :turbo_stream }

        it "returns a turbo_stream with a custom 'redir' action" do
          created_video = Video.find_by!(title: valid_video_params[:video][:title])
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
          assert_select "turbo-stream[action='redir'][target='#{video_url(created_video)}']", count: 1
        end

        it "sets a success flash message (which will be handled by Turbo Drive)" do
          expect(flash[:notice]).to eq("<i class='icon icon-check mx-1'></i> Video was successfully created.")
        end
      end

      context "response when HTML is requested" do
        it "redirects to the created video's show page and sets a flash message" do
          post videos_path, params: valid_video_params
          created_video = Video.last
          expect(response).to redirect_to(video_path(created_video))
          expect(flash[:notice]).to eq("<i class='icon icon-check mx-1'></i> Video was successfully created.")
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_video_params) do
        {
          video: {
            title: "",
            description: "Valid description but no title.",
            clip: valid_clip_file,
            thumbnail: valid_thumbnail_file
          }
        }
      end

      it "does not create a new Video" do
        expect {
          post videos_path, params: invalid_video_params, as: :turbo_stream
        }.to_not change(Video, :count)
      end

      context "response for failed creation" do
        before { post videos_path, params: invalid_video_params, as: :turbo_stream }

        it "returns an unprocessable_entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "re-renders the form within the 'add' turbo_frame with errors" do
          assert_select "turbo-frame#add" do
            assert_select "form[action=?][method=?]", videos_path, "post" do
              assert_select "input[name=?][value=?]", "video[title]", invalid_video_params[:video][:title]
              assert_select "textarea[name=?]", "video[description]", text: invalid_video_params[:video][:description]
              assert_select "div.has-error"
              expect(response.body).to include("Title can&#39;t be blank")
            end
          end
        end

        it "does not set a success flash message" do
          expect(flash[:notice]).to be_nil
          expect(flash[:success]).to be_nil
        end
      end
    end
  end

  describe "GET /videos/:id (edit)" do
    before { get edit_video_path(video1) }

    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renders the edit video form within a turbo_frame identified as 'add'" do
      assert_select "turbo-frame#add" do
        assert_select "form[action=?][method=?]", video_path(video1), "post" do
          assert_select "input[type=?][name=?][value=?]", "hidden", "_method", "patch", count: 1
          assert_select "input[name=?][value=?]", "video[title]", video1.title
          assert_select "textarea[name=?]", "video[description]", text: video1.description
          assert_select "input[type=?][name=?]", "file", "video[clip]"
          assert_select "input[type=?][name=?]", "file", "video[thumbnail]"
        end
      end
    end
  end

  describe "PATCH /videos/:id (update)" do
    context "with valid parameters" do
      let(:updated_attributes) do
        {
          video: {
            title: "Updated Video Title",
            description: "Updated video description."
          }
        }
      end

      context "response when TURBO_STREAM is requested" do
        before { patch video_path(video1), params: updated_attributes, as: :turbo_stream }

        it "updates the requested video's attributes" do
          video1.reload
          expect(video1.title).to eq(updated_attributes[:video][:title])
          expect(video1.description).to eq(updated_attributes[:video][:description])
        end

        it "returns a turbo_stream response with a 'refresh' action" do
          expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
          assert_select "turbo-stream[action='refresh'][target='']", count: 1
        end

        it "sets a success flash message (which will be handled by Turbo Drive)" do
          expect(flash[:notice]).to eq("<i class='icon icon-check mx-1'></i> Video was successfully updated.")
        end
      end

      context "response when HTML is requested" do
        before { patch video_path(video1), params: updated_attributes }

        it "updates the requested video's attributes and sets a flash message" do
          video1.reload
          expect(video1.title).to eq(updated_attributes[:video][:title])
          expect(video1.description).to eq(updated_attributes[:video][:description])
          expect(flash[:notice]).to eq("<i class='icon icon-check mx-1'></i> Video was successfully updated.")
        end

        it "redirects to the video's show page" do
          expect(response).to redirect_to(video_path(video1))
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_parameters) do
        { video: { title: "" } }
      end

      before { patch video_path(video1), params: invalid_parameters, as: :turbo_stream }

      it "does not update the video's attributes" do
        original_title = video1.title
        video1.reload
        expect(video1.title).to eq(original_title)
      end

      it "returns an unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the form within the 'add' turbo_frame with errors" do
        assert_select "turbo-frame#add" do
          assert_select "form[action=?][method=?]", video_path(video1), "post" do
            assert_select "input[name=?][value=?]", "video[title]", ""
            assert_select "div.has-error"
            expect(response.body).to include("Title can&#39;t be blank")
          end
        end
      end
    end
  end

  describe "DELETE /videos/:id (destroy)" do

    it "destroy the targeted video" do
      expect { delete video_path(video1) }.to change(Video, :count).by(-1)
    end

    it "redirects to the video's list" do
      delete video_path(video1)
      expect(response).to redirect_to(root_url(format: :html))
    end

    it "sets a success flash message" do
      delete video_path(video1)
      expect(flash[:notice]).to eq("Video was successfully destroyed.")
    end

    context "when the video has associated comments (testing dependent: :destroy)" do
      let!(:comment1) { create(:comment, video: video1) }
      let!(:comment2) { create(:comment, video: video1) }

      it "destroys the video and its associated comments" do
        expect { delete video_path(video1) }.to change(Video, :count).by(-1).and change(Comment, :count).by(-2)
      end
    end
  end
end
