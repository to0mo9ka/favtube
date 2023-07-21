class Relationship < ApplicationRecord
  enum status: {
    pending: 0,  # フォローリクエスト送信済み
    approved: 1  # フォローリクエスト承認済み
  }
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  # 非公開アカウントの所有者がフォローリクエストを承認するメソッド
  def approved_follow_request(requester)
    return unless followed.private_account?

    relationship = requester.following_relationships.find_by(followed: followed, status: 0)
    return unless relationship

    relationship.update(status: 1)
  end
end
