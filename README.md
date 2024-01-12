# Recipe Discover

## User Stories
1. As a User, I want to search for recipes based on ingredients, so I can find dishes that I can cook with the available items in my kitchen.
   - Acceptance Criteria:
     - There should be a checklist of ingredients to filter recipes.
     - I can type ingredients into the search bar to easily select my ingredients.
     - As I select ingredients, the list of recipes should be updated to show relevant recipes.

2. As a User, I want to view detailed information about a recipe, including ingredients, preparation and cooking time, and images.
    - Acceptance Criteria:
        - If the recipe includes external images, they should be loaded into the application.
        - The recipe information should be clearly displayed to help me choose the most relevant recipe.

## Running locally

Ruby version: **3.3.0**

Node version: **18.19.0**

Yarn version: **1.22.19**

Postgresql version: **14.10**

1. Clone the repository:
```shell
git clone https://github.com/Polanket/recipe-discover.git
```
2. Install dependencies:
```shell
bundle install
yarn install
```
3. Setup the database: (Make sure you have postgres running)
```shell
rails db:create
rails db:migrate
rails db:seed
```
* The seeding process might take a minute or two
4. Start the server:
```shell
bin/dev
```
