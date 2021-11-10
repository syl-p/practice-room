import { Controller } from "@hotwired/stimulus"
import { Remarkable } from "remarkable"

export default class extends Controller {
  static targets = [ "field", "result" ]
  static md = new Remarkable()

  connect() {
    const content = this.fieldTarget.value
    this.convert(content)
  }

  convert(markdown) {
    this.resultTarget.innerHTML = new Remarkable().render(markdown)
  }

  onChange($event) {
    this.convert($event.target.value)
  }

}
