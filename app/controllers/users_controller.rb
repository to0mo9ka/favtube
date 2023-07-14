class UsersController < ApplicationController
  def index
    @users = User.all
    @video = Video.new
  end
  
  def show
    @user = User.find(params[:id])
    @video = Video.new
    @videos = @user.videos.page(params[:page]).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end
  
  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
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
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
