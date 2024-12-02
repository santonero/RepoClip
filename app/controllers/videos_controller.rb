class VideosController < ApplicationController
  include Pagination
  before_action :set_video, only: %i[show edit update destroy]
  VIDS_PER_PAGE = 17

  def index
    @pagination, @videos = paginate(collection: Video.with_attached_thumbnail.all.order(created_at: :desc), params: page_params)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def search
    @pagination, @videos = paginate(collection: Video.with_attached_thumbnail.where("replace(title,' ','') ILIKE replace(?,' ','')", "%"+ Video.sanitize_sql_like(params[:query]) +"%").order(created_at: :desc), params: page_params)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    respond_to do |format|
      if @video.save
        flash[:notice] = "<i class='icon icon-check mx-1'></i> Video was successfully created."
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redir, video_url(@video)) }
        format.html { redirect_to video_url(@video) }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @video.update(video_params)
        flash[:notice] = "<i class='icon icon-check mx-1'></i> Video was successfully updated."
        format.turbo_stream { render turbo_stream: turbo_stream.action(:refresh, "") }
        format.html { redirect_to video_url(@video) }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video.destroy
    respond_to do |format|
      flash[:notice] = "Video was successfully destroyed."
      format.turbo_stream { render turbo_stream: turbo_stream.action(:redir, root_url) }
      format.html { redirect_to root_url(format: :html) }
      format.json { head :no_content }
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, alert: "Video does not exist."
  end

  def video_params
    if params[:video][:description].blank?
      params.expect(video: [:title, :clip, :thumbnail]).with_defaults(description: "No description here")
    else
      params.expect(video: [:title, :clip, :thumbnail, :description])
    end
  end

  def page_params
    params.permit(:page).merge(per_page: VIDS_PER_PAGE)
  end
end
