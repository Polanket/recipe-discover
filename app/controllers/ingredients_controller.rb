class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.where("ingredients.name ILIKE ?", "%#{params[:query]}%")
    render json: @ingredients
  end
end
