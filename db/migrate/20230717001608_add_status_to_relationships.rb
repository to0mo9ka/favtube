# db/migrate/xxxxx_add_status_to_relationships.rb

class AddStatusToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :status, :integer, default: 0
  end
end