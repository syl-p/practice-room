import styles from './collapse.style';
export class Collapse extends HTMLElement {
  constructor() {
    super();
    this.currentTab = 0;
    this.shadow = this.attachShadow({mode: 'open'})
  }

  connectedCallback() {
    const title = this.getAttribute('title')

    this.shadow.innerHTML = `
      <style>${styles}</style>
      <div class="collapse-section">
        <button type="button" class="collapse-section__btn">
          <span>${title}</span>
          <span>
            <!-- open -->
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
            </svg>

            <!-- close -->
            <svg class="h-5 w-5" style="display: none;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M5 10a1 1 0 011-1h8a1 1 0 110 2H6a1 1 0 01-1-1z" clip-rule="evenodd" />
            </svg>
          </span>
        </button>
        <div class="collapse-section__content" style="display: none;">
          <slot></slot>
        </div>
      </div>
    `

    // Get structure
    this.btn = this.shadow.querySelector('button')
    this.openIcon = this.btn.querySelector("svg:first-child")
    this.closeIcon = this.btn.querySelector("svg:last-child")
    this.content = this.shadow.querySelector('slot').parentElement

    this.btn.addEventListener('click', () => {
      this.toggle()
    })
  }

  toggle() {
    if (this.content.style.display === 'none') {
      this.content.style.display = 'block'
      this.openIcon.style.display = 'none'
      this.closeIcon.style.display = 'block'
    } else {
      this.content.style.display = 'none'
      this.openIcon.style.display = 'block'
      this.closeIcon.style.display = 'none'
    }
  }
}
