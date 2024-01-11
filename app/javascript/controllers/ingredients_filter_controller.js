import { Controller } from "@hotwired/stimulus"
import debounce from 'lodash/debounce';

// Connects to data-controller="ingredients-filter"
export default class extends Controller {

  static targets = ['input', 'list', 'checkbox']

  initialize() {
    this.search = debounce(this.search, 500)
  }

  search() {
    const query = this.inputTarget.value;
    const checkedIngredients = this.getCheckedIngredients()
    const checkedIngredientsIds = checkedIngredients.map(div => div.querySelector('input[type=checkbox]').value)

    fetch(`/ingredients?query=${query}`)
        .then(r => r.json())
        .then(data => {
          this.upgradeIngredientsList(data, checkedIngredients, checkedIngredientsIds)
          this.updateRecipes(checkedIngredientsIds)
        })
  }

  getCheckedIngredients() {
    return this.checkboxTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.parentNode);
  }

  upgradeIngredientsList(data, checkedIngredients, checkedIngredientsIds) {
    let html = ''

    data.forEach(ingredient => {
      if (!checkedIngredientsIds.includes(ingredient.id.toString())) {
        html += `<div class="col-12">
                 <input type="checkbox" id="ingredient_${ingredient.id}" name="ingredient" 
                    data-ingredients-filter-target="checkbox" 
                    data-action="change->ingredients-filter#triggerCheckbox" value="${ingredient.id}" />
                 <label for="ingredient_${ingredient.id}">${ingredient.name}</label>
               </div>`
      }
    })
    this.listTarget.innerHTML = html;

    checkedIngredients.forEach(div => {
      this.listTarget.prepend(div)
    })
  }

  updateRecipes(checkedIngredientsIds) {
    const src = `/recipes.turbo_stream?query=${checkedIngredientsIds}`;
    const recipes_div = document.getElementById('recipes_turbo');
    const siblings = Array.from(recipes_div.parentNode.children).filter(child => child !== recipes_div);

    siblings.forEach(sibling => {
      sibling.parentNode.removeChild(sibling)
    })
    recipes_div.src = src;
    recipes_div.reload()
  }

  triggerCheckbox(event) {
    const checkedIngredients = this.getCheckedIngredients()
    const checkedIngredientsIds = checkedIngredients.map(div => div.querySelector('input[type=checkbox]').value)
    this.updateRecipes(checkedIngredientsIds);
  }
}
