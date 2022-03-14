import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["videoPlayer", 'inputVersionsEnabled', 'versionsListEdit']
  static values = {
    root: String
  }

  connect() {
  }

  inputVersionsEnabledTargetConnected() {
    this.showVersionList(this.inputVersionsEnabledTarget.checked)
  }

  get practicerSidebarController() {
    return this.application.controllers.find(c => c.identifier === "practicer-sidebar")
  }

  get practicerNavControllers() {
    return this.application.controllers.filter(c => c.identifier === "practicer-nav")
  }

  get csrfToken() {
    const element = document.head.querySelector(`meta[name="csrf-token"]`)
    return element ? element.getAttribute("content") : null
  }

  get root() {
    return this.rootValue
  }

  togglePracticerSidebar() {
    this.practicerSidebarController.toggle();
  }

  // Version actions
  showVersion($event) {
    const versionVideoId = $event.target.dataset.videoId
    if (versionVideoId && this.videoPlayerTarget) {
      this.videoPlayerTarget.setAttribute('video-id', versionVideoId)
    }
  }

  toggleVersionsEnabled($event) {
    this.showVersionList($event.target.checked)
  }

  showVersionList(bool) {
    if (bool) {
      this.versionsListEditTarget.classList.remove('disabled')
      // remove disabled attribute from all inputs checkbox
      this.versionsListEditTarget.querySelectorAll('input[type="checkbox"]').forEach(input => {
        input.removeAttribute('disabled')
      })
    } else {
      this.versionsListEditTarget.classList.add('disabled')
      // add disabled attribute to all inputs checkbox
      this.versionsListEditTarget.querySelectorAll('input[type="checkbox"]')
      .forEach(input => {
        input.setAttribute('disabled', 'disabled')
        }
      )
    }
  }
}
