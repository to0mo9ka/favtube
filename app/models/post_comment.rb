class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  has_many :favorite_comments, dependent: :destroy

  def favorited_by?(user)
    favorite_comments.where(user_id: user.id).exists?
  end
end
