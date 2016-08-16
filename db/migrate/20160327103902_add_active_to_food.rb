class AddActiveToFood < ActiveRecord::Migration
  def change
    add_column :foods, :active, :boolean
  end
end
