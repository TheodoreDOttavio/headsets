class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :phone, default: '2125551234'
      t.string :phonetype, default: 'sprint'
      t.string :password_digest
      t.string :remember_token
      t.boolean :txtupdate, default: true # receive next week's schedule by text
      t.boolean :alert, default: false # receive text alerts?
      t.integer :alerttime, default: 3 # hours before curtain
      t.boolean :schedule, default: true
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :remember_token
  end
end
