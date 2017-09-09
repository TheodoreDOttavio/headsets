class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.integer :performance_id, null: false
      t.datetime :monday, null: false # Monday represents week of, the date the log begins
      t.boolean :specialservices, default: false

      t.timestamps null: false
    end

    add_index :scans, :performance_id
  end
end
