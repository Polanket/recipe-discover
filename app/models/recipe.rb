class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :included_ingredients, through: :recipe_ingredients, source: :ingredient
end
