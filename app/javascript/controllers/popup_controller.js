import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "dialog" ]

  connect() {
    // click outside of the popup to close it
  }

  // hide modal on successful form submission
  // data-action="turbo:submit-end->turbo-modal#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      // console.log(e.detail.success)
      this.close()
    }
  }

  open() {
    this.dialogTarget.showModal()
    document.body.classList.add('overflow-hidden')
  }

  close() {
    this.dialogTarget.close()
    document.body.classList.remove('overflow-hidden')
  }

  clickOutside(event) {
    if (event.target == this.dialogTarget) {
      this.close()
    }
  }
}
