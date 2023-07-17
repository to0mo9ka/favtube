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
  
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人
  
  has_many :follower_relationships, foreign_key: "followed_id", class_name: "Relationship"
  has_many :followed_relationships, foreign_key: "follower_id", class_name: "Relationship"
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :followed_users, through: :followed_relationships, source: :followed

  
  # ユーザーをフォローする
  def follow(followed_id)
    follower.create(followed_id: followed_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end
  
  # フォローリクエストを承認する
  def approve_follow_request(follower)
    request = follower_relationships.find_by(followed: self)
    request.update(status: 'approved') if request
  end
  
  # フォローリクエストを送信しているかどうかを確認するメソッド
  def pending_follow_request?(user)
    follower.exists?(followed: user, status: 'pending')
  end
  
  # ユーザーが特定のユーザーのフォローリクエストを承認しているかどうかを確認
  def approved_follow_request?(user)
    followed.exists?(follower: user, status: 'approved')
  end
end
