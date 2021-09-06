import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = ["btn"]
  static values = {exerciseId: Number}

  connect() {
    practice(this)
  }

  favorites($event) {
    this.favorite(this.exerciseIdValue, $event.target.dataset.favoriteAction)
      .then((response) => {
        switch ($event.target.dataset.favoriteAction) {
          case "add":
            const favoritesTarget = super.practicerSidebarController.favoritesTarget
            // add element to list
            favoritesTarget.innerHTML = favoritesTarget.innerHTML + response

            // UPDATE BTN
            $event.target.dataset.favoriteAction = "remove"
            $event.target.innerHTML = `<i class="icon icon-bookmark"></i> Retirer de mes favoris`
            break;
          case "remove":
            const favorite = Array.from(favoritesTarget.children).find(c => parseInt(c.dataset.exerciseId) === this.exerciseIdValue)
            if (favorite) {
              favorite.remove()
            }

            // UPDATE BTN
            $event.target.dataset.favoriteAction = "add"
            $event.target.innerHTML = `<i class="icon icon-bookmark"></i> Ajouter à mes favoris`
            break;
          default:
            break;
        }
      })
      .catch(err => console.log(err))
  }
}
