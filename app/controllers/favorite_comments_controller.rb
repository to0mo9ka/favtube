class FavoriteCommentsController < ApplicationController
  def create
    post_comment = PostComment.find(params[:post_comment_id])
    favorite_comment = current_user.favorite_comments.new(post_comment_id: post_comment.id)
    favorite_comment.save
    video = post_comment.video
    redirect_to video_path(video)
  end

  def destroy
    post_comment = PostComment.find(params[:post_comment_id])
    favorite_comment = current_user.favorite_comments.find_by(post_comment_id: post_comment.id)
    favorite_comment.destroy
    video = post_comment.video
    redirect_to video_path(video)
  end
end
