class RecipesController < ApplicationController
  def index
    @recipes = Recipe.joins(:recipe_ingredients)
                      .group('recipes.id')
                      .select('recipes.*, COUNT(distinct recipe_ingredients.ingredient_id) as ingredient_matches, COUNT(DISTINCT total_ingredients.ingredient_id) as total_ingredients')
                      .joins("LEFT JOIN recipe_ingredients as total_ingredients ON total_ingredients.recipe_id = recipes.id")
                      .limit(100)

    @recipes = @recipes.where(recipe_ingredients: { ingredient_id: params[:query].split(',') })
                                .order('ingredient_matches DESC, total_ingredients ASC') if params[:query].present?

    @ingredients = Ingredient.common_ingredients
  end
end
