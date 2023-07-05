class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  has_many :favorite_comments, dependent: :destroy
  validates :comment, presence: true, length: { maximum: 1000 }
  def favorited_by?(user)
    favorite_comments.where(user_id: user.id).exists?
  end
end
