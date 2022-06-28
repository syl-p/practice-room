import ApplicationController from "./application_controller"
import { practice } from "./mixins/practice"

export default class extends ApplicationController {
  static targets = ["exercises", "exercise", "challenges",
  "favorites", "logNav", "practiceTime"]

  static values = {
    date: String,
  }

  connect() {
    practice(this)
  }

  exerciseTargetConnected() {
    this.evalPracticeTime()
  }

  exerciseTargetDisconnected() {
    this.evalPracticeTime()
  }

  dateValueChanged() {
    const $dateLinks = document.querySelectorAll(`.day-selector a.day-selector__week-day`)
    $dateLinks.forEach(($dl) => {
      if ($dl.dataset.date == this.dateValue) {
        $dl.classList.add('active')
      } else {
        $dl.classList.remove('active')
      }
    })
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
