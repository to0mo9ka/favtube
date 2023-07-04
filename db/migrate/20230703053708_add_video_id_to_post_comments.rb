class AddVideoIdToPostComments < ActiveRecord::Migration[5.2]
  def change
    add_column :post_comments, :video_id, :integer
  end
end
