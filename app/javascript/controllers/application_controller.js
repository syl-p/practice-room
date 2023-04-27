import { Controller } from "@hotwired/stimulus"
import { leave, enter } from "../transistion"

export default class extends Controller {
  static targets = ["videoPlayer", 'inputVersionsEnabled',
    'versionsListEdit', 'videoPreviewer', "sidebar", "favorites"]

  static values = {
    root: String,
    activeNav: String,
  }

  connect() {
    this.currentUrl = window.location.href

    // Open exercise_sidebar if we are on exercise page
    const exerciseRegex = /^\/exercises\/\d+$/; // expression régulière pour correspondre à /exercises/[nombre entier]
    if (exerciseRegex.test(window.location.pathname)) {
      // const exerciseId = parseInt(window.location.pathname.split("/")[2]);
      this.sidebarShow({params: {id: "exercise_sidebar"}})
    }

    // TURBO Event listening
    document.addEventListener('turbo:frame-load', (event) => {
      // Open exercise_sidebar for frame exercise_show
      if (event.target.id === "exercise_show") {
        this.sidebarShow({params: {id: "exercise_sidebar"}})
        window.history.pushState({url: event.target.src}, "", event.target.src);
      }
    });

    // Go back btn, close the popup
    window.addEventListener("popstate", (event) => {
      window.history.replaceState({}, '', event.state.previousUrl);
      this.sidebarHide({params: {id: "exercise_sidebar"}})
    });
  }

  sidebarTargetConnected(sidebar) {
    // Close on click outside a sidebar
    sidebar.addEventListener('click', (event) => {
      if (event.target !== event.currentTarget)
      return;
      this.sidebarHide({params: {id: sidebar.id}})
      if(sidebar.id === 'exercise_sidebar') {
        window.history.replaceState({}, '', this.currentUrl);
      }
    })
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
    const sidebar = this.sidebarTargets.find(s => s.getAttribute('id') == id)
    const sidebar_content = sidebar.querySelector('aside')

    sidebar.classList.remove('hidden')
    enter(sidebar)

    sidebar_content.classList.remove('hidden')
    enter(sidebar_content)
  }

  sidebarHide({ params: { id }}) {
    const sidebar = this.sidebarTargets.find(s => s.getAttribute('id') == id)
    const sidebar_content = sidebar.querySelector('aside')
    Promise.all([
      leave(sidebar_content),
      leave(sidebar)
    ]).then(() => {
      // this.overlayTarget.classList.add("hidden")
      // sidebar.classList.add('hidden')
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
