class RecipesController < ApplicationController
  def index
    @recipes = Recipe.first(20)
    @ingredients = Ingredient.first(100)
    @found_recipes = []
  end
end
