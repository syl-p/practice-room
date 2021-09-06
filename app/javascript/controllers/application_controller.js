import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    // console.log(this.application)
  }

  get practicerSidebarController() {    
    return this.application.controllers.find(c => c.identifier === "practicer-sidebar")
  }

  get practicerNavController() {
    return this.application.controllers.find(c => c.identifier === "practicer-nav")
  }

  get csrfToken() {
    const element = document.head.querySelector(`meta[name="csrf-token"]`)
    return element ? element.getAttribute("content") : null
  }

  togglePracticerSidebar() {
    this.practicerSidebarController.toggle();
  }
}
