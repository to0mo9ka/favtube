class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    if @user.private_account?
      current_user.follow(@user.id, status: :pending) # リクエスト済みとしてフォロー作成
      flash[:notice] = "フォローリクエストを送信しました。"
    else
      current_user.follow(@user.id, status: :approved) # 承認済みとしてフォロー作成
      flash[:notice] = "フォローしました。"
    end

    redirect_to @user
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    redirect_to @user
  end
end
