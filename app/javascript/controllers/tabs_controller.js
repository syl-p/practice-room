import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["tabLink", "tab"]

  connect() {
      this.currentTab = 0
      this.showCurrentTab()
  }

  changeTab($event) {
    $event.preventDefault()
    this.currentTab = parseInt($event.target.dataset.tabsIndex)
    this.showCurrentTab()
  }

  showCurrentTab() {
    // Update content
    this.tabTargets.forEach((element, index) => {
        element.hidden = index !== this.currentTab
    });
    // Update nav
    this.tabLinkTargets.forEach(e => e.classList.remove('active'))
    this.tabLinkTargets[this.currentTab].classList.add('active')
  }
}
