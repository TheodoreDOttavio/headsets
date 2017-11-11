class DropAvailablesTable < ActiveRecord::Migration
  def up
    drop_table :availables
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
