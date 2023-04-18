class CommentsController < ApplicationController
http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy

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
    redirect_to video_path(@video), status: :see_other
  end
  
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
