class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :payrate, default: 48 # amount paid to rep to distribute this
      t.string :comments
      t.integer :options

      t.timestamps
    end
  end
end
