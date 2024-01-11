import { Controller } from "@hotwired/stimulus"
import debounce from 'lodash/debounce';

// Connects to data-controller="ingredients-filter"
export default class extends Controller {

  static targets = ['input', 'list']

  initialize() {
    this.search = debounce(this.search, 500)
  }

  search() {
    const query = this.inputTarget.value;
    const checkedIngredients = this.getCheckedIngredients()

    fetch(`/ingredients?query=${query}`)
        .then(r => r.json())
        .then(data => {
          this.upgradeIngredientsList(data, checkedIngredients)
        })
  }

  getCheckedIngredients() {
    return Array.from(this.listTarget.querySelectorAll('input[type=checkbox]:checked')).map(checkbox => checkbox.parentNode)
  }

  upgradeIngredientsList(data, checkedIngredients) {
    const checkedIngredientsIds = checkedIngredients.map(div => div.querySelector('input[type=checkbox]').value)
    let html = ''

    data.forEach(ingredient => {
      if (!checkedIngredientsIds.includes(ingredient.id.toString())) {
        html += `<div class="col-12">
                 <input type="checkbox" id="ingredient_${ingredient.id}" name="ingredient" value="${ingredient.id}" />
                 <label for="ingredient_${ingredient.id}">${ingredient.name}</label>
               </div>`
      }
    })
    this.listTarget.innerHTML = html;

    checkedIngredients.forEach(div => {
      this.listTarget.prepend(div)
    })
  }
}
