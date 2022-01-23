import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = [ "container", "exercises", "exercise", "challenges",
  "favorites", "logNav", "practiceTime"]

  connect() {
    practice(this)
    // CLICK outside to remove active class the sidebar
    document.addEventListener('click', (e) => {
      if (!this.containerTarget.contains(e.target)
        && e.target.dataset.action != "click->application#togglePracticerSidebar") {
        this.containerTarget.classList.remove('active')
      }
    })
  }


  logNavTargetConnected(element) {
    const a = this.containerTarget.querySelector(".panel-nav ul li a")
    if(a) {
      a.innerHTML = element.dataset.date
    }
  }

  exerciseTargetConnected() {
    this.evalPracticeTime()
  }

  exerciseTargetDisconnected() {
    this.evalPracticeTime()
  }

  convertHMS(value) {
    const sec = parseInt(value, 10); // convert value to number if it's string
    let hours   = Math.floor(sec / 3600); // get hours
    let minutes = Math.floor((sec - (hours * 3600)) / 60); // get minutes
    let seconds = sec - (hours * 3600) - (minutes * 60); //  get seconds
    // add 0 if value < 10; Example: 2 => 02
    if (hours   < 10) {hours   = "0"+hours;}
    if (minutes < 10) {minutes = "0"+minutes;}
    if (seconds < 10) {seconds = "0"+seconds;}
    return hours+':'+minutes+':'+seconds; // Return is HH : MM : SS
  }

  evalPracticeTime() {
    let res = 0
    this.exerciseTargets.forEach(e => {
      res += parseInt(e.dataset.duration);
    })
    this.practiceTimeTarget.innerHTML = this.convertHMS(res)
  }

  toggle($event = null) {
    if ($event) {
      $event.preventDefault()
    }
    this.containerTarget.classList.toggle('active')
  }

  removeFromFavorites({params: {id}}) {
    this.favorite(id, 'remove')
      .then(() => {
          const favorite = Array.from(this.favoritesTarget.children).find(c => c.dataset.exerciseId == id)
          if (favorite) {
            favorite.remove()
            // Get the good button in practicerNav controllers
            const controller = super.practicerNavControllers.find(c => c.exerciseIdValue == id)
            if (controller) {
              controller.btnTargets[1].dataset.practicerNavActionParam = "add"
              controller.btnTargets[1].innerHTML = `<i class="icon icon-bookmark"></i> ${controller.extendedValue ? "Ajouter à mes favoris" : ''}`
            }
          }
      })
      .catch(err => {

      })
  }
}
