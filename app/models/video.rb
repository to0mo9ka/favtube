class Video < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :youtube_url, presence: true, format: {
    with: %r{\A(https?://)?(www\.)?youtu\.?be(/watch\?v=|/)([\w-]+)(\S+)?\z},
    message: "is not a valid YouTube URL"
  }
  validates :body, presence: true, length: { maximum: 200 }
  
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
