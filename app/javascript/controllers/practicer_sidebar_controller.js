import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = [ "container", "exercises", "challenges", "favorites", "logNav"]

  connect() {
    practice(this)
  }

  logNavTargetConnected(element) {
    const a = this.containerTarget.querySelector(".panel-nav ul li a")
    if(a) {
      a.innerHTML = element.dataset.date
    }
  }

  toggle($event = null) {
    if ($event) {
      $event.preventDefault()
    }
    this.containerTarget.classList.toggle('close')
  }

  removeFromFavorites({params: {id}}) {
    this.favorite(id, 'remove')
      .then((response) => {
          const favorite = Array.from(this.favoritesTarget.children).find(c => c.dataset.exerciseId === id)
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
