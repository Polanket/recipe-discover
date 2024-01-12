class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  def self.common_ingredients
    Ingredient.joins(:recipe_ingredients)
              .select('ingredients.*, COUNT(recipe_ingredients.id) AS count_id')
              .group('ingredients.id')
              .order('count_id DESC')
              .limit(100)
  end
end
