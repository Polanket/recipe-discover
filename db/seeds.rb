puts "Seeding database. This may take a couple of minutes..."

json_file_path = Rails.root.join('db', 'seeds', 'recipes-en.json')

recipes_data = JSON.parse(File.read(json_file_path))

def clean_up_ingredients(ingredients)
  words_to_remove = ['teaspoon', 'teaspoons', 'tablespoons', 'tablespoon', 'cup', 'cups', 'to', 'taste', 'inch', 'degrees', 'f', 'c',
                     'peeled', 'pinch', 'or', 'as', 'more', 'and', 'into', 'chopped', 'beaten', 'softened', 'ounce', 'ounces', 'fluid', 'needed',
                     'diced', 'slice', 'slices', 'sliced', 'quart', 'quarts', 'chilled', 'divided', 'minced', 'such', 'large',
                     'small', 'medium', 'melted', 'pound', 'pounds', 'seeded', 'thin', 'cut', 'pieces', 'crushed', 'shredded', /\d+/]

  ingredients.map do |ingredient|
    cleaned_ingredient = ingredient.gsub(/\b(?:#{Regexp.union(words_to_remove).source})\b|[^\w\s]/, ' ').strip
    cleaned_ingredient = cleaned_ingredient.gsub(/\s+/, ' ').titleize

    cleaned_ingredient
  end
end

recipes = []
recipe_ingredients = []

puts "Creating recipes..."
recipes_data.each do |recipe_data|
  recipe = Recipe.new(
    title: recipe_data['title'],
    cook_time: recipe_data['cook_time'],
    prep_time: recipe_data['prep_time'],
    ingredients: recipe_data['ingredients'],
    ratings: recipe_data['ratings'],
    cuisine: recipe_data['cuisine'],
    category: recipe_data['category'],
    author: recipe_data['author'],
    image_url: recipe_data['image']
  )

  puts "Added #{recipe_data['title']}"
  recipes << recipe

  puts "Creating ingredients..."
  cleaned_ingredients = clean_up_ingredients(recipe_data['ingredients'])
  cleaned_ingredients.each do |ingredient_name|
    puts "Added #{ingredient_name}"
    ingredient = Ingredient.where(name: ingredient_name).first_or_create
    recipe_ingredients << RecipeIngredient.new(recipe: recipe, ingredient: ingredient)
  end
end

puts "Saving to database..."
Recipe.import recipes

recipe_ingredients.each(&:save!)

puts 'Seeding completed.'
