class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_video, only: :show
  def index
    @video = Video.new
    # 自分の投稿のIDを取得
    my_post_ids = current_user.videos.pluck(:id)

    # 公開アカウントのユーザーIDを取得
    public_user_ids = User.where(account_type: 0).pluck(:id)

    # フォローリクエストが承認されたユーザーのIDを取得
    approved_followers_ids = current_user.following_relationships.where(status: 1).pluck(:followed_id)

    # 承認してくれた非公開アカウントの投稿のIDを取得
    approved_private_post_ids = Video.joins(:user).where(user_id: approved_followers_ids, users: { account_type: 1 }).pluck(:id)

    # 自分の投稿と公開アカウントの投稿と承認してくれた非公開アカウントの投稿のIDを取得
    post_ids_to_show = my_post_ids + Video.where(user_id: public_user_ids).pluck(:id) + approved_private_post_ids

    # 上記の投稿IDを持つ投稿を取得
    @videos = Video.where(id: post_ids_to_show).page(params[:page]).reverse_order

  end

  def show
    if current_user_can_view?(@video)
      @post_comment = PostComment.new
      @user = @video.user
    else
      redirect_to user_path(current_user)
    end
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
  def find_video
    @video = Video.find(params[:id])
  end

  def current_user_can_view?(video)
    # 自分の投稿か、公開アカウントの投稿か、承認してくれた非公開アカウントの投稿の場合にtrueを返す
    current_user == video.user ||
      video.user.account_type == 0 ||
      current_user.approved_follow_request?(video.user)
  end
  
  def video_params
    params.require(:video).permit(:title, :youtube_url, :body)
  end

end
