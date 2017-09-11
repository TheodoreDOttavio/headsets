class AddColumToScans < ActiveRecord::Migration
  def change
    add_column :scans, :isprocessed, :boolean, default: false
  end
end
