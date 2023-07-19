class User < ApplicationRecord
  enum account_type: {
    public_account: 0,   # 公開アカウント
    private_account: 1   # 非公開アカウント
  }
  
  def self.account_types
    {
      public_account: '公開アカウント',
      private_account: '非公開アカウント'
      # もしくは必要な他のアカウントタイプを追加
    }
  end
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :videos, dependent: :destroy
  attachment :profile_image
  
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
  
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_comments, dependent: :destroy
  
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :following_relationships, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed_relationships, source: :follower # 自分をフォローしている人
  
  #has_many :follower_relationships, foreign_key: "followed_id", class_name: "Relationship"
  #has_many :followed_relationships, foreign_key: "follower_id", class_name: "Relationship"
  #has_many :followers, through: :follower_relationships, source: :follower
  #has_many :followed_users, through: :followed_relationships, source: :followed
  #has_many :following, through: :followed_relationships, source: :followed

  
  # ユーザーをフォローする
  def follow(followed_id, status: 'approved')
    following_relationships.create(followed_id: followed_id, status: status)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
  relationship = following_relationships.find_by(followed_id: user_id)
  relationship.destroy if relationship
  end


  # フォローしていればtrueを返す
  def following?(user)
    following_relationships.exists?(followed: user, status: 'approved')
  end
  
  # フォローリクエストを承認する
  def approve_follow_request(follower)
    request = follower_relationships.find_by(followed: self)
    request.update(status: 'approved') if request
  end
  
  # フォローリクエストを送信しているかどうかを確認するメソッド
  def pending_follow_request?(user)
    following_relationships.exists?(followed: user, status: 'pending')
  end
  
  # フォローリクエストが承認されていれば true を返す
  def approved_follow_request?(user)
    # followed_relationships を使ってフォローリクエストが承認されているかを確認する
    relationship = followed_relationships.find_by(follower_id: user.id, status: 'approved')

    # 必要に応じてログを出力して実行結果を確認する
    puts "Checking approved_follow_request? for user_id=#{self.id} and follower_id=#{user.id}"

    if relationship
      puts "Follow request is approved."
    else
      puts "Follow request is not approved."
    end

    # フォローリクエストが承認されていれば true を返す
    return relationship.present?
  end
  
  def approve_follow_request(requester)
    return unless private_account?

    relationship = follower.following_relationships.find_by(followed: self, status: :pending)
    return unless relationship

    relationship.update(status: :approved)
  end
  
end
