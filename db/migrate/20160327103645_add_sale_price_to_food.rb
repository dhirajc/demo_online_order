class AddSalePriceToFood < ActiveRecord::Migration
  def change
    add_column :foods, :sale_price, :float
  end
end
