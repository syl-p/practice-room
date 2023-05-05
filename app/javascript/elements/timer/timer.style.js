export default `
  .timer {
    text-align: center;
  }

  .timer button:not(.timer__reset) {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: #4995f6;
    color: white;
    box-shadow: transparent;
    border: 0;
    display: block;
    margin: auto;
    cursor: pointer;
  }

  .timer button:not(.timer__reset) svg {
    width: 50px;
  }

  .timer__show {
    font-weight: bold;
    font-size: 25px;
  }

  .timer button.timer__reset {
    display: inline;
    cursor: pointer;
  }
`
