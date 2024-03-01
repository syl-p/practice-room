import { Controller } from "@hotwired/stimulus"
import { leave, enter } from "../transistion"

export default class extends Controller {
  static targets = ['inputVersionsEnabled',
    'versionsListEdit', "sidebar", "favorites", "overlay"]

  static values = {
    root: String,
    activeNav: String,
  }

  connect() {
    this.currentUrl = window.location.href
  }

  sidebarTargetConnected() {
    // Close on click outside a sidebar
    this.overlayTarget.addEventListener('click', (event) => {
      if (event.target !== event.currentTarget)
        return;
      this.sidebarHide()
    })
  }

  inputVersionsEnabledTargetConnected() {
    this.showVersionList(this.inputVersionsEnabledTarget.checked)
  }

  get practicerNavControllers() {
    return this.application.controllers.filter(c => c.identifier === "practice-toolbar")
  }

  get csrfToken() {
    const element = document.head.querySelector(`meta[name="csrf-token"]`)
    return element ? element.getAttribute("content") : null
  }

  get root() {
    return this.rootValue
  }

  toggle(e) {
    if(this.sidebarTarget) {
      if (this.sidebarTarget.classList.contains('hidden')) {
        if (window.innerWidth < 1280) {
          this.sidebarShow()
        }
      } else {
        this.sidebarHide()
      }
    }
  }

  sidebarShow() {
    const sidebar = this.sidebarTarget
    this.overlayTarget.classList.remove('hidden')
    sidebar.classList.remove('hidden')
    enter(sidebar)
  }

  sidebarHide() {
    const sidebar = this.sidebarTarget
    Promise.all([
      // leave(sidebar_content),
      leave(sidebar)
    ]).then(() => {
      // this.overlayTarget.classList.add("hidden")
      sidebar.classList.add('hidden')
      this.overlayTarget.classList.add('hidden')
      // enter(sidebar)
    })
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
