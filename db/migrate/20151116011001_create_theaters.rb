class CreateTheaters < ActiveRecord::Migration
  def change
    create_table :theaters do |t|
      t.string :name, null: false
      t.string :address
      t.string :city, default: 'New York'
      t.string :state, default: 'NY'
      t.string :zip
      t.string :phone
      t.string :company
      t.string :comments
      t.string :commentsentrance, default: 'Enter by the stage door'
      t.string :commentsworklocation, default: 'Console location'
      t.string :commentslock, limit: 6

      t.timestamps
    end
  end
end
