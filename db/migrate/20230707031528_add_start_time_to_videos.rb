class AddStartTimeToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :start_time, :integer
  end
end
