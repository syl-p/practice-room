import styles from "./skeleton.style"
export class Skeleton extends HTMLElement {
  constructor() {
    super()
    this.shadow = this.attachShadow({mode: 'closed'})
  }

  connectedCallback() {
    const placeholder = this.getAttribute('placeholder') || '-'
    const width = this.size(this.getAttribute('width'), placeholder == '-')
    const height = this.size(this.getAttribute('height'))
    const lines = parseInt(this.getAttribute('lines') || 0)
    const rounded = this.getAttribute('rounded') || false

    let spans = '<span></span>'
    if (lines > 0) {
      for (let i = 0; i < lines; i++) {
        spans += '<span></span>'
      }
    }

    this.shadow.innerHTML = `
      <style>
        ${styles}
        span {
          width: ${width};
          height: ${height};
          border-radius: ${rounded ? '100px' : '0'};
        }
        span::before {
          content: "${placeholder}";
          opacity: 0;
        }
      </style>
      ${spans}
    `
  }

  size(size, fallbackTo100) {
    if (size) {
      if (size.match(/^[0-9]+$/)) {
        size += 'px'
      }
      return size
    } else if (fallbackTo100) {
      return '100%'
    }
    return 'auto'
  }
}
