class Video < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  
  validates :youtube_url, presence: true, format: {
  with: %r{\A(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/)([\w-]+)(\S+)?(\?t=\d+s?)?\z},
  message: "is not a valid YouTube URL"}
  
  validates :body, presence: true, length: { maximum: 200 }
  
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  before_save :extract_start_time_from_url

  private

  def extract_start_time_from_url
    if youtube_url =~ /t=(\d+)/
      self.start_time = $1.to_i
    end
  end


  
end
