class RemoveStartTimeFromVideos < ActiveRecord::Migration[5.2]
  def change
    remove_column :videos, :start_time, :integer
  end
end
