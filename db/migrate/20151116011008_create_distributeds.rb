class CreateDistributeds < ActiveRecord::Migration
  def change
    create_table :distributeds do |t|
      t.integer :performance_id, null: false
      t.integer :product_id, null: false
      t.datetime :curtain, null: false
      t.boolean :eve, default: true
      t.integer :quantity, null: true
      t.integer :language, null: false, default: 0 # ! for the mixboard mikes (english)
      t.integer :general, null: true, default: 0 # 0=Booked, 1=Infrared, 2=Special Services
      t.integer :representative

      t.timestamps
    end

    add_index :distributeds, :performance_id
    add_index :distributeds, :product_id
    add_index :distributeds, [:performance_id, :product_id]
  end
end
