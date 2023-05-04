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
          play
        </button>
        <button class="timer__stop" style="display: none;">
          stop
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
