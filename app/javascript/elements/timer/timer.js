import styles from './timer.style';
export class Timer extends HTMLElement {
  constructor() {
    super();
    this.currentTab = 0;
    this.shadow = this.attachShadow({mode: 'open'})
  }

  connectedCallback() {
    const defaultTime = this.getAttribute('value') ?? "00:10:00"

    this.shadow.innerHTML = `
      <style>${styles}</style>
      <div class="timer">
        <button class="timer__play">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z" />
          </svg>
        </button>
        <button class="timer__stop" style="display: none;">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 5.25v13.5m-7.5-13.5v13.5" />
          </svg>
        </button>
        <div class="timer__show">
          <input type="time" value="${defaultTime}" />
          <button class="timer__reset">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
            </svg>
          </button>
        </div>
      </div>
    `

    // Get structure
    this.btnPlay = this.shadow.querySelector('button.timer__play')
    this.btnStop = this.shadow.querySelector('button.timer__stop')
    this.btnReset = this.shadow.querySelector('button.timer__reset')
    this.input = this.shadow.querySelector('.timer__show input')
    this.elapsedTime = 0

    this.btnPlay.addEventListener('click', () => {
      this.start()
      this.btnPlay.style.display = "none"
      this.btnStop.style.display = "block"
    })

    this.btnStop.addEventListener('click', () => {
      this.stop()
      this.btnStop.style.display = "none"
      this.btnPlay.style.display = "block"
    })

    this.btnReset.addEventListener('click', () => {
      this.reset()
      this.btnStop.style.display = "none"
      this.btnPlay.style.display = "block"
    })

    this.input.addEventListener('change', e => {
      this.dispatchEvent(new CustomEvent('change', {
        detail: {elapsedTime: this.elapsedTime, timerShow: e.target.value}
      }))
    })
  }

  start() {
    this.timer = setInterval(() => {
      this.elapsedTime += 1000
      const value = this.formattedElapsedTime(this.elapsedTime)
      this.input.value = value
      this.dispatchEvent(new CustomEvent('change', {
        detail: {elapsedTime: this.elapsedTime, timerShow: this.input.value}
      }))
    }, 1000);
  }

  stop() {
    clearInterval(this.timer)
    this.timer = undefined
  }

  reset() {
    this.stop()
    this.elapsedTime = 0
    this.input.value = "00:00:00"
    this.dispatchEvent(new CustomEvent('change', {
      detail: {elapsedTime: 0, timerShow: this.input.value}
    }))
  }

  formattedElapsedTime(value) {
    const date = new Date(null);
    date.setSeconds(value / 1000);
    const utc = date.toUTCString();
    return utc.substr(utc.indexOf(":") - 2, 8);
  }
}
