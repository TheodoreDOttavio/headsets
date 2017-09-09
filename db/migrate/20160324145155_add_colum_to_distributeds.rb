class AddColumToDistributeds < ActiveRecord::Migration
  def change
    add_column :distributeds, :isinfrared, :boolean, default: false
    add_column :distributeds, :scan, :boolean, default: false
  end
end
