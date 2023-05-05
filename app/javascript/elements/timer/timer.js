import styles from './timer.style';
export class Timer extends HTMLElement {
  constructor() {
    super();
    this.currentTab = 0;
    this.shadow = this.attachShadow({mode: 'open'})
  }

  connectedCallback() {
    const title = this.getAttribute('title')

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
        <p class="timer__show">00:00:00</p> <button class="timer__reset">reset</button>
      </div>
    `

    // Get structure
    this.btnPlay = this.shadow.querySelector('button.timer__play')
    this.btnStop = this.shadow.querySelector('button.timer__stop')
    this.btnReset = this.shadow.querySelector('button.timer__reset')
    this.timerShow = this.shadow.querySelector('p.timer__show')
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
  }

  start() {
    this.timer = setInterval(() => {
      this.elapsedTime += 1000
      const value = this.formattedElapsedTime(this.elapsedTime)
      this.timerShow.innerHTML = value
    }, 1000);
  }

  stop() {
    clearInterval(this.timer)
    this.timer = undefined
  }

  reset() {
    this.stop()
    this.elapsedTime = 0
    this.timerShow.innerHTML = "00:00:00"
  }

  formattedElapsedTime(value) {
    const date = new Date(null);
    date.setSeconds(value / 1000);
    const utc = date.toUTCString();
    return utc.substr(utc.indexOf(":") - 2, 8);
  }
}
