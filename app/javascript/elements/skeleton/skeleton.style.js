export default `
  :host {
    display: block;
  }

  span {
    display: inline-block;
    position: relative;
    overflow: hidden;
    background-color: var(--skeleton, #f5f5f5);
  }

  span::after {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    animation: waves 1.6s linear .5s infinite;
    transform: translateX(-100px);
    background: linear-gradient(90deg, transparent, var(--skeleton-wave, rgba(0,0,0, 0.07)), transparent);
  }

  @keyframes waves {
    0% {
      transform: translateX(-100px);
    }
    60% {
      transform: translateX(100%);
    }
    100% {
      transform: translateX(100%);
    }
  }
`
