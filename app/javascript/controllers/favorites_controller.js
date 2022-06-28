import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = ["favorites", "item"]

  connect() {
    practice(this)
  }

  removeFromFavorites({params: {id}}) {
    this.favorite(id, 'remove')
      .then(() => {
          console.log(this.favoritesTarget)
          console.log(this.favoritesTarget.querySelector('li'))
          const favorite = Array.from(this.favoritesTarget.querySelectorAll('li')).find(c => c.dataset.exerciseId == id)
          if (favorite) {
            favorite.remove()
            // Get the good button in practicerNav controllers
            const controller = super.practicerNavControllers.find(c => c.exerciseIdValue == id)
            if (controller) {
              controller.btnTargets[1].dataset.practicerNavActionParam = "add"
              controller.btnTargets[1].innerHTML = `<i class="mdi mdi-bookmark-outline"></i> ${controller.extendedValue ? "Ajouter à mes favoris" : ''}`
            }
          }
      })
      .catch(err => {

      })
  }
}
