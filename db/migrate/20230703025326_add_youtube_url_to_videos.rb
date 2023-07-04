class AddYoutubeUrlToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :youtube_url, :string
  end
end
