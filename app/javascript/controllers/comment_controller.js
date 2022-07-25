import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
    static targets = [ "form" ]


  connect() {
    // this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  display($event) {
    $event.preventDefault();
    const  commentsForm = document.querySelectorAll('.comment_form')
    commentsForm.forEach(cf => cf.classList.add('hidden'))
    this.formTarget.classList.toggle('hidden')
  }

  submit($event) {
    // fire search
    this.timeout = setTimeout(() => {
      Rails.fire($event.target.closest("form"), 'submit')
      this.formTarget.classList.add('hidden')
      this.formTarget.querySelector('textarea').value = ''
    }, 100)
  }

  cancel($event) {
    $event.preventDefault()
    this.formTarget.classList.add('hidden')
    this.formTarget.querySelector('textarea').value = ''
  }
}
