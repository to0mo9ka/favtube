class UsersController < ApplicationController
  def index
    @users = User.all
    @video = Video.new
  end

  def show
  @user = User.find(params[:id])
  @video = Video.new
  @following_users = @user.following_user
  @follower_users = @user.follower_user

  if @user.private_account?
    if !current_user.approved_follow_request?(@user) && @user != current_user
      @videos = []
      # 非公開のメッセージを表示するコードを追加
      puts "User's videos are private and follow request is not approved."
    else
      @videos = @user.videos.page(params[:page]).reverse_order
    end
  else
    @videos = @user.videos.page(params[:page]).reverse_order
  end
  end


  def follow
  @user = User.find(params[:id])
  if current_user.following?(@user)
    current_user.unfollow(@user)
    flash[:notice] = "フォローを解除しました。"
  elsif @user.private_account?
    current_user.follow(@user, status: :pending)
    flash[:notice] = "フォローリクエストを送信しました。"
  else
    current_user.follow(@user, status: :approved)
    flash[:notice] = "フォローしました。"
  end


  redirect_to @user
  end


  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(10).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(10).reverse_order
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])

    if @user == current_user
      if @user.update(user_params)
        flash[:notice] = "You have updated user successfully."
        redirect_to user_path(current_user)
      else
        render :edit
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :account_type)
  end
end
