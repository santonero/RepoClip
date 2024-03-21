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
        format.html { redirect_to video_url(@video), notice: "<i class='icon icon-check mx-1'></i> Video was successfully created." }
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
        format.html { redirect_to video_url(@video), notice: "<i class='icon icon-check mx-1'></i> Video was successfully updated." }
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
      format.html { redirect_to root_url(format: :html), notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, alert: "<i class='icon icon-search mx-1'></i> Video does not exist."
  end

  def video_params
    if params[:video][:description].blank?
      params.require(:video).permit(:title, :clip, :thumbnail).with_defaults(description: "No description here")
    else
      params.require(:video).permit(:title,:description, :clip, :thumbnail)
    end
  end

  def page_params
    params.permit(:page).merge(per_page: VIDS_PER_PAGE)
  end
end
