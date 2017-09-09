class AddOptionsToDistributeds < ActiveRecord::Migration
  def change
    change_column_default :distributeds, :representative, 0
  end
end
