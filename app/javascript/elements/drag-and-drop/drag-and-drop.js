import styles from './drag-and-drop.style'
import Rails from "@rails/ujs";

export class DragAndDrop extends HTMLElement {
  constructor() {
    super();
    this.shadow = this.attachShadow({mode: 'closed'})
  }

  connectedCallback() {
    this.shadow.innerHTML = `
      <style>${styles}</style>
      <div class="drag-and-drop">
        <div class="drag-and-drop_container">
          <label class="drag-and-drop__label">${this.getAttribute('label')}</label>
          <slot>
        </div>
        <ul></ul>
      </div>
    `

    this.dragAndDropContainer = this.shadow.querySelector('.drag-and-drop_container')
    this.input = this.querySelector('input[type="file"]')

    // Attach event
    this.shadow.addEventListener('dragover', () => {
      this.updateHolder('is-over')
    })

    this.shadow.addEventListener('dragleave', () => {
      this.restoreHolder()
    })

    this.shadow.addEventListener('drop', () => {
      this.restoreHolder()
    })

    this.input.addEventListener('input', (e) => {
      this.updateHolder('has-file')
      this.handleFiles(e.target.files)
    })
  }

  updateHolder(classToAdd) {
    this.dragAndDropContainer.classList.add(classToAdd);
  }

  restoreHolder() {
    this.dragAndDropContainer.classList.remove('is-over');
  }

  handleFiles(files) {
    const ul = this.shadow.querySelector("ul");
    ul.innerHTML = "";
    for (let i = 0; i < files.length; i++) {
      const li = document.createElement("li");

      const deleteButton = document.createElement("button");
      deleteButton.classList.add("file-delete-button");
      deleteButton.textContent = "Delete";
      deleteButton.addEventListener("click", () => {
        this.handleFileDelete(i);
      });

      li.innerHTML = files[i].name;
      li.appendChild(deleteButton);

      if (ul) {
        ul.append(li);
      }
    }
  }

  handleFileDelete(index) {
    const ul = this.shadow.querySelector("ul");
    console.log(index, ul.children)
    const files = Array.from(this.input.files)
    files.splice(index, 1)
    const newFileList = new DataTransfer()
    files.forEach(file => {
      newFileList.items.add(file)
    })
    this.input.files = newFileList.files

    // Supprimer le fichier de l'affichage
    const li = ul.children[index];
    li.remove();

    this.handleFiles(this.input.files)
  }
}
