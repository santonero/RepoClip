class CommentsController < ApplicationController
  include Pagination
  http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy

  POSTS_PER_PAGE = 6

  def show
    @video = Video.find(params[:video_id])
    @pagination, @comments = paginate(collection: @video.comments, params: page_params)
  end

  def new
    @video = Video.find(params[:video_id])
    @comment = @video.comments.new
  end
 
  def create
    @video = Video.find(params[:video_id])
    @comment = @video.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to video_path(@video), notice: "Comment was successfully added." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video = Video.find(params[:video_id])
    @comment = @video.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to video_path(@video), status: :see_other }
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end

    def page_params
      params.permit(:page).merge(per_page: POSTS_PER_PAGE)
    end
end
