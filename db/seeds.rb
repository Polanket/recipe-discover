puts "Seeding database. This may take a couple of minutes..."

json_file_path = Rails.root.join('db', 'seeds', 'recipes-en.json')

recipes_data = JSON.parse(File.read(json_file_path))

def clean_up_ingredients(ingredients)
  words_to_remove = ['teaspoon', 'teaspoons', 'tablespoons', 'tablespoon', 'cup', 'cups', 'to', 'taste',
                     'peeled', 'pinch', 'or', 'as', 'more', 'and', 'into', 'chopped', 'beaten', 'softened', 'ounce', 'ounces',
                     'diced', 'slice', 'slices', 'quart', 'quarts', 'chilled', 'divided', 'minced', 'such', 'large',
                     'small', 'medium', 'melted', 'seeded', 'cut', 'pieces', 'crushed', 'shredded', /\d+/]

  ingredients.map do |ingredient|
    cleaned_ingredient = ingredient.downcase.gsub(/\b(?:#{Regexp.union(words_to_remove).source})\b|[^\w\s]/, '').strip
    cleaned_ingredient = cleaned_ingredient.gsub(/\s+/, '')

    cleaned_ingredient
  end
end

recipes = []
recipe_ingredients = []

recipes_data.each do |recipe_data|

  recipe = Recipe.new(
    title: recipe_data['title'],
    cook_time: recipe_data['cook_time'],
    prep_time: recipe_data['prep_time'],
    ratings: recipe_data['ratings'],
    cuisine: recipe_data['cuisine'],
    category: recipe_data['category'],
    author: recipe_data['author'],
    image_url: recipe_data['image']
  )
  recipes << recipe

  cleaned_ingredients = clean_up_ingredients(recipe_data['ingredients'])
  cleaned_ingredients.each do |ingredient_name|

    ingredient = Ingredient.new(name: ingredient_name)
    recipe_ingredients << RecipeIngredient.new(recipe: recipe, ingredient: ingredient)
  end
end

Recipe.import recipes

Ingredient.import(recipe_ingredients.map(&:ingredient).uniq)

recipe_ingredients.each(&:save!)

puts 'Seeding completed.'
