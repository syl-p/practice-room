import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ["practiceLink", "selectedTime", "timer"]

  static values = {
    date: String,
  }

  connect() {
  }

  timerTargetConnected() {
    this.timerTarget.addEventListener('change', e => {
      this.changePracticeLinkTimeParams(e.detail.timerShow)
    })
  }

  selectedTimeTargetConnected() {
    this.selectedTimeTarget.addEventListener('change', (e) => {
      this.changePracticeLinkTimeParams(this.selectedTimeTarget.value)
    })
  }

  changePracticeLinkTimeParams(time = null) {
    const form = this.practiceLinkTarget.parentNode
    const url = new URL(form.action)
    const search = url.searchParams
    url.search = search.toString()

    if (time) {
      search.set('time', time)
    } else {
      search.delete(time)
    }

    form.action = url
  }
}
