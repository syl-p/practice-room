import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]
  static classes = [ "toggle" ]

  connect() {
    document.addEventListener('click', (e) => {
      if (!this.menuTarget.contains(e.target) && !this.buttonTarget.contains(e.target)
        && !this.menuTarget.classList.contains(this.toggleClass)) {
        this.menuTarget.classList.add(this.toggleClass)
      }
    })
  }

  toggle() {
    this.menuTarget.classList.toggle(this.toggleClass)
  }
}
