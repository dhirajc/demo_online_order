class AddShortdescriptionToFood < ActiveRecord::Migration
  def change
    add_column :foods, :short_description, :string
  end
end
