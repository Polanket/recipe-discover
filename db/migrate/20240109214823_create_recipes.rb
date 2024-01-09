class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false, default: ""
      t.integer :cook_time, default: 0
      t.integer :prep_time, default: 0
      t.string :ingredients, array: true, default: []
      t.float :ratings, default: 0.0
      t.string :cuisine, default: ""
      t.string :category, default: ""
      t.string :author, default: ""
      t.string :image_url, default: ""

      t.timestamps
    end
  end
end
