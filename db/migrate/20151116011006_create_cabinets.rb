class CreateCabinets < ActiveRecord::Migration
  def change
    create_table :cabinets do |t|
      t.integer :performance_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false

      t.timestamps
    end

    add_index :cabinets, :performance_id
    add_index :cabinets, :product_id
    add_index :cabinets, [:performance_id, :product_id] # , unique: true
  end
end
