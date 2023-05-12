export default `
  .timer {
    text-align: center;
  }

  .timer button {
    cursor: pointer;
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
  }

  .timer button:not(.timer__reset) svg {
    width: 50px;
  }

  .timer__show {
    display: flex;
    margin: auto;
    align-items: center;
    justify-content: center;
    gap: 10px;
  }

  .timer__show input{
    font-weight: bold;
    font-size: 35px;
    margin: 10px 0;
    border: none;
  }

  button.timer__reset {
    border: none;
    background: none;
    cursor: pointer;
    margin: 0;
    padding: 0;
  }

  button.timer__reset svg {
    width: 20px;
  }
`
