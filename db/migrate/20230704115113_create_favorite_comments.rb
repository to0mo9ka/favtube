class CreateFavoriteComments < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_comments do |t|
      t.integer :user_id
      t.integer :post_comment_id

      t.timestamps
    end
  end
end
