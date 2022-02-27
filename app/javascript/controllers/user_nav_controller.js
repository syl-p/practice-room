import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "invitationsList", "invitationsCount", "invitation" ]

  connect() {
    this.invitationsCountEval()
  }

  invitationsCountEval() {
    this.invitationsCountTarget.dataset.badge = this.invitationTargets.length

    if(this.invitationTargets.length > 0) {
      this.invitationsCountTarget.classList.add('badge')
    } else {
      this.invitationsCountTarget.classList.remove('badge')
    }
  }

  invitationTargetConnected() {
    this.invitationsCountEval()
  }

  invitationTargetDisconnected() {
    this.invitationsCountEval()
  }
}
