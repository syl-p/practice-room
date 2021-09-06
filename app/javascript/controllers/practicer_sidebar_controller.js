import { Controller } from "stimulus"
import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = [ "container", "exercises", "challenges", "favorites"]

  connect() {
    practice(this)
  }

  toggle($event = null) {
    if ($event) {
      $event.preventDefault()
    }
    this.containerTarget.classList.toggle('close')
  }

  removeFromFavorites($event) {
    const exId = $event.currentTarget.parentElement.parentElement.dataset.exerciseId
    this.favorite(exId, 'remove')
      .then((response) => {
          const favorite = Array.from(this.favoritesTarget.children).find(c => c.dataset.exerciseId === exId)
          if (favorite) {
            favorite.remove()
            // UPDATE BTN
            super.practicerNavController.btnTargets[1].dataset.favoriteAction = "add"
            super.practicerNavController.btnTargets[1].innerHTML = `<i class="icon icon-bookmark"></i> Ajouter à mes favoris`
          
          }
      })
      .catch(err => {

      })
  }
}
