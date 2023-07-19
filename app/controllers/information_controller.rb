class InformationController < ApplicationController
  def index
    # ページの処理や表示内容を追加する
    # 現在のユーザーに送信されているフォローリクエストを取得
    @follow_requests = current_user.followed_relationships.where(status: 'pending')
  end
  def approve_request
    request_id = params[:request_id]
    request = Relationship.find_by(id: request_id)
    if request
      request.update(status: 'approved')
      redirect_to information_index_path, notice: 'フォローリクエストを承認しました。'
    else
      redirect_to information_index_path, alert: 'リクエストが見つかりませんでした。'
    end
  end

  def reject_request
    request_id = params[:request_id]
    request = Relationship.find_by(id: request_id)
    if request
      request.destroy
      redirect_to information_index_path, notice: 'フォローリクエストを拒否しました。'
    else
      redirect_to information_index_path, alert: 'リクエストが見つかりませんでした。'
    end
  end
end
