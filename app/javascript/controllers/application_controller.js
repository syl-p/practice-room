import { Controller } from "@hotwired/stimulus"
import { leave, enter } from "../transistion"

export default class extends Controller {
  static targets = ["videoPlayer", 'inputVersionsEnabled',
    'versionsListEdit', 'videoPreviewer', "sidebar", "overlay", "favorites"]

  static values = {
    root: String,
    activeNav: String,
  }

  connect() {
  }

  inputVersionsEnabledTargetConnected() {
    this.showVersionList(this.inputVersionsEnabledTarget.checked)
  }

  videoPreviewerTargetConnected() {
    // observe text input in the target
    const textInput = this.videoPreviewerTarget.querySelector('input')
    textInput.addEventListener('input', () => { // and change youtube-player video id
      this.videoPreviewerTarget.querySelector('youtube-player').setAttribute('video-id', textInput.value)
    })
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

  sidebarShow({ params: { id }}) {
    this.overlayTarget.classList.remove('hidden')
    enter(this.overlayTarget)

    const sidebar = this.sidebarTargets.find(s => s.getAttribute('id') == id)
    sidebar.classList.remove('hidden')
    enter(sidebar)
  }

  sidebarHide({ params: { id }}) {
    const sidebar = this.sidebarTargets.find(s => s.getAttribute('id') == id)

    Promise.all([
      leave(sidebar),
      leave(this.overlayTarget)
    ]).then(() => {
      this.overlayTarget.classList.add("hidden")
      sidebar.classList.add('hidden')
      enter(sidebar)
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
