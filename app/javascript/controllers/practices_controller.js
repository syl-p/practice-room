import helper from "../helper"
import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = ["exercise", "practiceLink", "practiceTime", "selectedTime", "timer"]

  static values = {
    date: String,
  }

  connect() {
    practice(this)
  }

  exerciseTargetConnected() {
    this.evalPracticeTime()
  }

  timerTargetConnected() {
    this.timerTarget.addEventListener('change', e => {
      this.changePracticeLinkTimeParams(e.detail.timerShow)
    })
  }

  exerciseTargetDisconnected() {
    this.evalPracticeTime()
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

  evalPracticeTime() {
    let res = 0
    this.exerciseTargets.forEach(e => {
      res += parseInt(e.dataset.duration);
    })
    this.practiceTimeTarget.innerHTML = helper.convertHMS(res)
  }
}
