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

  convertHMS(value) {
    const sec = parseInt(value, 10); // convert value to number if it's string
    let hours   = Math.floor(sec / 3600); // get hours
    let minutes = Math.floor((sec - (hours * 3600)) / 60); // get minutes
    let seconds = sec - (hours * 3600) - (minutes * 60); //  get seconds
    // add 0 if value < 10; Example: 2 => 02
    if (hours   < 10) {hours   = "0"+hours;}
    if (minutes < 10) {minutes = "0"+minutes;}
    if (seconds < 10) {seconds = "0"+seconds;}
    return hours+':'+minutes+':'+seconds; // Return is HH : MM : SS
  }

  evalPracticeTime() {
    let res = 0
    this.exerciseTargets.forEach(e => {
      res += parseInt(e.dataset.duration);
    })
    this.practiceTimeTarget.innerHTML = this.convertHMS(res)
  }
}
