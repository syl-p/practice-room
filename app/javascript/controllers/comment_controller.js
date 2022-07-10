import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "form" ]


  connect() {
    // this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  display($event) {
    $event.preventDefault();
    const  commentsForm = document.querySelectorAll('.comment .comment_form')
    commentsForm.forEach(cf => cf.classList.add('hidden'))
    this.formTarget.classList.toggle('hidden')
  }

  cancel($event) {
    $event.preventDefault()
    this.formTarget.classList.add('hidden')
    this.formTarget.querySelector('textarea').value = ''
  }
}
