class Relationship < ApplicationRecord
  enum status: {
    pending: 0,  # フォローリクエスト送信済み
    approved: 1  # フォローリクエスト承認済み
  }
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  # 非公開アカウントの所有者がフォローリクエストを承認するメソッド
  def approve_follow_request(requester)
    return unless followed_relationships.private_account?

    relationship = followed_relationships.find_by(follower_id: requester.id)
    return unless relationship&.pending?

    relationship.update(status: :approved)
  end
end
