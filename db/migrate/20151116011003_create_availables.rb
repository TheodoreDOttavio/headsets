class CreateAvailables < ActiveRecord::Migration
  def change
    create_table :availables do |t|
      t.belongs_to :user, default: 1
      t.datetime :day, null: false
      t.boolean :eve, default: true
      t.boolean :free, default: false

      t.timestamps
    end

    add_index :availables, :user_id
  end
end
