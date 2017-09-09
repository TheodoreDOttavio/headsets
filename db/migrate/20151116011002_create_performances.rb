class CreatePerformances < ActiveRecord::Migration
  # duration is in minutes
  #  intermission as minutes from curtain
  def change
    create_table :performances do |t|
      t.belongs_to :theater, default: 1
      t.string :name, null: false
      t.integer :duration, default: 180
      t.integer :intermission, default: 90
      t.datetime :opening
      t.datetime :closeing
      t.string :comments

      t.timestamps
    end

    add_index :performances, :theater_id
  end
end
