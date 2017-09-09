class AddColumToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :specialservices, :boolean, default: false
  end
end
