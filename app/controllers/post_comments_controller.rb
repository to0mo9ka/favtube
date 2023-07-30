class PostCommentsController < ApplicationController
  def create
    video = Video.find(params[:video_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.video_id = video.id
    if comment.save
      flash[:notice] = 'You have created comment successfully.'
      redirect_to video_path(video)
    else
      redirect_to video_path(video)
    end
  end
  
  def destroy
    PostComment.find_by(id: params[:id]).destroy
    redirect_to video_path(params[:video_id])
  end
  
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end