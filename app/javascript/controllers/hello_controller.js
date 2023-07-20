import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "results", "skeleton" ]
  initialize() {
    this.cloneSkeleton = null
  }

  connect() {
  }

  skeletonTargetConnected() {
    this.cloneSkeleton = this.skeletonTarget.cloneNode(true)
  }

  search($event) {
    clearTimeout(this.timeout)

    // insert custom element skeleton in the results target DOM
    this.resultsTarget.innerHTML = this.cloneSkeleton.innerHTML

    // fire search
    this.fireForm($event, 500)
  }

  fireForm($event, timeout = 200) {
    const parentForm = $event.target.closest("form")
    this.timeout = setTimeout(() => {
      Rails.fire(parentForm, 'submit')
    }, timeout)
  }
}
