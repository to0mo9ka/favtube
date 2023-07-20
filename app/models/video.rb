class Video < ApplicationRecord
  enum account_type: {
    public_account: 0,   # 公開アカウント
    private_account: 1   # 非公開アカウント
  }
  
  belongs_to :user
  validates :title, presence: true
  
  validates :youtube_url, presence: true, format: {
  with: %r{\A(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/)([\w-]+)(\S+)?(\?t=\d+s?)?(&enablejsapi=1)?\z},
  message: "is not a valid YouTube URL"}
  
  validates :body, presence: true, length: { maximum: 200 }
  
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
