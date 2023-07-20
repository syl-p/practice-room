import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "popup", "popupContent" ]
  static classes = [ "active", "inactive"]

  connect() {
    // click outside of the popup to close it
    document.addEventListener('click', (e) => {
      if (!this.popupContentTarget.contains(e.target)) {
        // remove class
        this.popupTarget.classList.add(this.inactiveClass)
        this.popupTarget.classList.remove(this.activeClass)
      }
    })
  }

  toggle($event) {
    if ($event.target) {
      document.activeElement.blur()
    }
    this.popupTarget.classList.remove(this.inactiveClass)
    this.popupTarget.classList.toggle(this.activeClass)
  }
}
