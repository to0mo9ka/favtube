class AddJumpTimeToPostComments < ActiveRecord::Migration[5.2]
  def change
    add_column :post_comments, :jump_time, :integer
  end
end
