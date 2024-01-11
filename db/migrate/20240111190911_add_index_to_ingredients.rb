class AddIndexToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_index :ingredients, :name
  end
end
