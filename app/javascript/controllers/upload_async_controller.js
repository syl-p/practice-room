import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "inputFile", "progress", "progressText", "progressWidth" ]

  initialize() {
  }

  progressTargetConnected() { // display none on page load
    this.progressTarget.style.display = "none"
  }

  connect() {
    // Direct upload events
    this.element.addEventListener('direct-upload:initialize', event => {})
    this.element.addEventListener("direct-upload:progress", event => {
      this.progressTarget.style.display = "block"
      const { id, progress } = event.detail
      // this.progressWidthTarget.style.width = `${Math.round(progress)}%`
      this.progressWidthTarget.value = Math.round(progress)
      this.progressTextTarget.innerHTML = `${Math.round(progress)}% complete`
    })

    this.element.addEventListener("direct-upload:error", event => {
      console.log("test", event)
      event.preventDefault()
      const { id, error } = event.detail
      console.log(error)
    })
  }

  upload() {
    Rails.fire(this.element.closest('form'), 'submit')
  }

/*  disconnect() {
    this.element.removeEventListener("direct-upload:progress", this.updateProgress)
  }*/
}
