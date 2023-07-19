class InformationController < ApplicationController
  def index
    # ページの処理や表示内容を追加する
    # 現在のユーザーに送信されているフォローリクエストを取得
    @follow_requests = current_user.followed_relationships.where(status: 'pending')
  end
  def approve_request
    request = Relationship.find(params[:request_id])
    request.update(status: 'approved')
    redirect_to information_index_path, notice: 'フォローリクエストを承認しました。'
  end

  def reject_request
    request = Relationship.find(params[:request_id])
    request.destroy
    redirect_to information_index_path, notice: 'フォローリクエストを拒否しました。'
  end
end
