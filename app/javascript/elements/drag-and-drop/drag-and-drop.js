import styles from './drag-and-drop.style'
export class DragAndDrop extends HTMLElement {
  constructor() {
    super();
    this.shadow = this.attachShadow({mode: 'closed'})
  }

  connectedCallback() {
    this.shadow.innerHTML = `
      <style>${styles}</style>
      <div class="drag-and-drop">
        <label class="drag-and-drop__label">${this.getAttribute('label')}</label>
        <slot>
      </div>
    `

    this.dragAndDropContainer = this.shadow.querySelector('.drag-and-drop')
    this.input = document.querySelector('drag-and-drop input')
    console.log(this.input)

    // Attach event
    this.shadow.addEventListener('dragover', () => {
      this.updateHolder('is-over')
      console.log(this.input)
    })

    this.shadow.addEventListener('dragleave', () => {
      this.restoreHolder()
    })

    this.shadow.addEventListener('drop', () => {
      this.restoreHolder()
    })

    this.input.addEventListener('change', () => {
      this.updateHolder('has-file')
    })
  }

  updateHolder(classToAdd) {
    this.dragAndDropContainer.classList.add(classToAdd);
  }

  restoreHolder() {
    this.dragAndDropContainer.classList.remove('is-over');
  }
}
