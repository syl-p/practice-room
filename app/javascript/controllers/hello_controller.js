import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exercises" ]

  connect() {
    // this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  fetch($event) {
    fetch(`exercises?export=true&text=${$event.target.value}`)
      .then(response => response.text())
      .then(response => {
        this.exercisesTarget.innerHTML = response
      })
  }
}
