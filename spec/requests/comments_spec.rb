require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:video) { create(:video) }
  let!(:comment1) { create(:comment, video: video) }
  let!(:comment2) { create(:comment, video: video) }

  describe "GET /videos/:video_id/comments (index)" do
    before { get video_comments_path(video) }

    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "displays the list of comments for this video within a turbo_frame identified as 'comframe'" do
      assert_select "turbo-frame#comframe" do
        assert_select "div#comments" do
          assert_select "div#comment_#{comment1.id}" do
            assert_select "p span", comment1.commenter
            assert_select "p span", comment1.body
          end
          assert_select "div#comment_#{comment2.id}" do
            assert_select "p span", comment2.commenter
            assert_select "p span", comment2.body
          end
        end
      end
    end
  end

  describe "GET /videos/:video_id/comments/new (new)" do
    before { get new_video_comment_path(video) }

    it "returns a successful response" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renders the new comment form within a turbo_frame identified as 'new_comment'" do
      assert_select "turbo-frame#new_comment" do
        assert_select "form[action=?][method=?]", video_comments_path(video), "post" do
          assert_select "input[name=?]", "comment[commenter]"
          assert_select "textarea[name=?]", "comment[body]"
        end
      end
    end
  end

  describe "POST /videos/:video_id/comments (create)" do
    context "with valid parameters" do
      let(:valid_comment_params) { { comment: { commenter: "An Author", body: "A nice comment."} } }

      it "creates a new comment with the correct attributes when TURBO_STREAM is requested" do
        expect { post video_comments_path(video), params: valid_comment_params, as: :turbo_stream }.to change(Comment, :count).by(1)
        created_comment = Comment.find_by!(commenter: valid_comment_params[:comment][:commenter])
        expect(created_comment.body).to eq(valid_comment_params[:comment][:body])
      end

      it "renders a turbo_stream with a custom 'fcomreload' action" do
        post video_comments_path(video), params: valid_comment_params, as: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
        assert_select "turbo-stream[action='fcomreload'][target='']", count: 1
      end
    end

    context "with invalid parameters" do
      let(:invalid_comment_params) { { comment: { commenter: "", body: "z"} } }

      it "does not create a new comment" do
        expect { post video_comments_path(video), params: invalid_comment_params, as: :turbo_stream }.to_not change(Comment, :count)
      end

      before { post video_comments_path(video), params: invalid_comment_params, as: :turbo_stream }

      it "re-renders form within the 'new_comment' turbo_frame with errors" do
        assert_select "turbo-frame#new_comment" do
          assert_select "form[action=?][method=?]", video_comments_path(video), "post" do
            assert_select "input[name=?][value=?]", "comment[commenter]", invalid_comment_params[:comment][:commenter]
            assert_select "textarea[name=?]", "comment[body]", text: invalid_comment_params[:comment][:body]
            assert_select "div.has-error"
            assert_select "p.form-input-hint", "Author can't be blank"
            assert_select "p.form-input-hint", "Comment is too short (minimum is 2 characters)"
          end
        end
      end

      it "returns an unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /videos/:video_id/comments/:id (destroy)" do
    it "destroys the targeted comment" do
      expect { delete video_comment_path(video, comment1), as: :turbo_stream }.to change(Comment, :count).by(-1)
    end

    it "renders a turbo_stream with a custom 'comreload' action" do
      delete video_comment_path(video, comment1), as: :turbo_stream
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
      assert_select "turbo-stream[action='comreload'][target='']"
    end
  end
end
