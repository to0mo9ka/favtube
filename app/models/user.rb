class User < ApplicationRecord
  enum account_type: {
    public_account: 0,
    private_account: 1
  }
  
  after_initialize :set_default_account_type, if: :new_record?
  def set_default_account_type
    self.account_type ||= :public_account
  end
  
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
  def follow(followed_id, status: 1)
    following_relationships.create(followed_id: followed_id, status: status)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
  # 非公開アカウントの場合は承認済みのフォローリクエストのみを対象とする
  relationship = following_relationships.find_by(followed_id: user_id, status: 1)

  # フォローリクエストが承認されていればフォローを解除
  relationship.destroy if relationship
  end



  # フォローしていればtrueを返す
  def following?(user)
    following_relationships.exists?(followed: user, status: 1)
  end
  
  # フォローリクエストを承認する
  #def approved_follow_request(follower)
    #request = followed_relationships.find_by(followed: self)
    #request.update(status: 'approved') if request
  #end
  
  # フォローリクエストを送信しているかどうかを確認するメソッド
  def pending_follow_request?(user)
    following_relationships.exists?(followed: user, status: 0)
  end
  
  # フォローリクエストが承認されていれば true を返す
  def approved_follow_request?(user)
    # followed_relationships を使ってフォローリクエストが承認されているかを確認する
    relationship = following_relationships.find_by(followed_id: user.id, status: 1)

    # 必要に応じてログを出力して実行結果を確認する
    puts "Checking approved_follow_request? for followed_id=#{self.id} and follower_id=#{user.id}"

    if relationship
      puts "Follow request is approved."
    else
      puts "Follow request is not approved."
    end

    # フォローリクエストが承認されていれば true を返す
    return relationship.present?
  end
  
  #def approved_follow_request(user)
    #return unless private_account?

    #relationship = follower.following_relationships.find_by(followed: self, status: :pending)
    #return unless relationship

    #relationship.update(status: :approved)
  #end
  
  #def followed_relationships
    #Relationship.where(followed_id: self.id)
  #end
  
end
