import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "popup", "popupContent" ]
  static classes = [ "active" ]

  connect() {
    // click outside of the popup to close it
    document.addEventListener('click', (e) => {
      if (!this.popupContentTarget.contains(e.target)) {
        // reset turbo-frame to default state
        this.popupContentTarget.innerHTML = `
          <turbo-frame loading="lazy" id="medium-edit" src="/media/new">
              Chargement...
          </turbo-frame>
        `

        // remove class
        this.popupTarget.classList.remove(this.activeClass)
      }
    })
  }

  toggle($event) {
    $event.stopPropagation()
    if ($event.target) {
      document.activeElement.blur()
    }
    this.popupTarget.classList.toggle(this.activeClass)
  }
}
