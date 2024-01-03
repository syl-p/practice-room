import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["results"]
  initialize() {
    this.cloneSkeleton = null
  }

  connect() {
    document.addEventListener('click', (e) => {
      if (!this.element.contains(e.target) && this.hasResultsTarget) {
        this.resultsTarget.innerHTML = ''
      }
    })
  }

  // skeletonTargetConnected() {
  //   if (this.hasSkeletonTarget) {
  //     this.cloneSkeleton = this.skeletonTarget.cloneNode(true)
  //   }
  // }

  start($event) {
    clearTimeout(this.timeout)

    // // insert custom element skeleton in the results target DOM
    // if (this.hasResultsTarget && this.cloneSkeleton) {
    //   this.resultsTarget.innerHTML = this.cloneSkeleton.innerHTML
    // }

    // fire search
    this.fireForm($event, 500)
  }

  fireForm($event, timeout = 200) {
    const parentForm = $event.target.closest("form")
    if (!parentForm)
      return

    this.timeout = setTimeout(() => {
      Rails.fire(parentForm, 'submit')
    }, timeout)
  }
}
