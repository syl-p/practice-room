import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "form" ]


  connect() {
    // this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  display($event) {
    $event.preventDefault();
    const  commentsForm = document.querySelectorAll('.comment .comment_form')
    commentsForm.forEach(cf => cf.classList.add('d-none'))
    this.formTarget.classList.toggle('d-none')
  }

  cancel($event) {
    console.log($event)
    $event.preventDefault()
    this.formTarget.classList.add('d-none')
    this.formTarget.querySelector('textarea').value = ''
  }
}
