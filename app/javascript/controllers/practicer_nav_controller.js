import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = ["btn", "selectedTime"]
  static values = {
    exerciseId: Number,
    extended: Boolean,
    defaultTime: String
  }

  connect() {
    practice(this)
  }

  favorites({params: {id, action}}) {
    console.log(this.btnTargets)
    this.favorite(id, action)
      .then((response) => {
        const favoritesTarget = super.practicerSidebarController.favoritesTarget
        switch (action) {
          case "add":
            // add element to list
            favoritesTarget.innerHTML = favoritesTarget.innerHTML + response

            // UPDATE BTN
            this.btnTargets[1].dataset.practicerNavActionParam = "remove"
            this.btnTargets[1].innerHTML = `<i class="mdi mdi-bookmark-remove"></i> ${this.extendedValue ? "Retirer de mes favoris" : ''}`
            break;
          case "remove":
            const favorite = Array.from(favoritesTarget.children).find(c => parseInt(c.dataset.exerciseId) === parseInt(id))
            if (favorite) {
              favorite.remove()
            }

            // UPDATE BTN
            this.btnTargets[1].dataset.practicerNavActionParam = "add"
            this.btnTargets[1].innerHTML = `<i class="mdi mdi-bookmark-outline"></i> ${this.extendedValue ? "Ajouter à mes favoris" : ''}`
            break;
          default:
            break;
        }
      })
      .catch(err => console.log(err))
  }

  addToPractice({params: {id}}) {
    const time = this.selectedTimeTarget ? this.selectedTimeTarget.value : "00:10"
    this.practice(id, time)
      .then((response) => {
        const exercisesTarget = super.practicerSidebarController.exercisesTarget
        // add element to list
        exercisesTarget.innerHTML = response
      })
      .catch(err => console.log(err))
  }
}
