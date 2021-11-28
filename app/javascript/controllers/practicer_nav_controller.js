import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = ["btn"]
  static values = {exerciseId: Number}

  connect() {
    practice(this)
  }

  favorites({params: {id, action}}) {
    this.favorite(id, action)
      .then((response) => {
        const favoritesTarget = super.practicerSidebarController.favoritesTarget
        switch ($event.target.dataset.favoriteAction) {
          case "add":
            // add element to list
            favoritesTarget.innerHTML = favoritesTarget.innerHTML + response

            // UPDATE BTN
            this.btnTargets[1].target.dataset.PracticerNavActionParam = "remove"
            this.btnTargets[1].target.innerHTML = `<i class="icon icon-bookmark"></i> Retirer de mes favoris`
            break;
          case "remove":
            const favorite = Array.from(favoritesTarget.children).find(c => parseInt(c.dataset.exerciseId) === this.exerciseIdValue)
            if (favorite) {
              favorite.remove()
            }

            // UPDATE BTN
            this.btnTargets[1].dataset.PracticerNavActionParam = "add"
            this.btnTargets[1].innerHTML = `<i class="icon icon-bookmark"></i> Ajouter à mes favoris`
            break;
          default:
            break;
        }
      })
      .catch(err => console.log(err))
  }

  addToPractice($event) {
    this.practice(this.exerciseIdValue)
      .then((response) => {
        const exercisesTarget = super.practicerSidebarController.exercisesTarget
        // add element to list
        exercisesTarget.innerHTML = response
      })
      .catch(err => console.log(err))
  }
}
