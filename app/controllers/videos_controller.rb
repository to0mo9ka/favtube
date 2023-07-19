class VideosController < ApplicationController
  def index
    @video = Video.new
    following_users = current_user.following_user.where(relationships: { status: :approved })
    public_users = User.where(account_type: "public_account")
    @videos = Video.where(user: following_users).or(Video.where(user: public_users).or(Video.where(user: current_user))).page(params[:page]).reverse_order
  end

  def show
    @video = Video.find(params[:id])
    @post_comment = PostComment.new
    @user = @video.user
  end

  def create
    @video = Video.new(video_params)
    @video.user_id = current_user.id

    if @video.save
      flash[:notice] = 'You have created the video successfully.'
      redirect_to video_path(@video)
    else
      @videos = Video.all
      render :index
    end
  end

  def edit
    @video = Video.find(params[:id])
    if @video.user != current_user
      redirect_to videos_path
    end
  end
  
  def update
    @video = Video.find(params[:id])
    if @video.update(video_params)
      flash[:notice] = "You have updated video successfully."
      redirect_to video_path
    else
      render :edit
    end
  end
  
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to videos_path
  end
  
  protected
  
  def video_params
    params.require(:video).permit(:title, :youtube_url, :body)
  end

end
