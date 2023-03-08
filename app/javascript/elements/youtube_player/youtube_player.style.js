export default `
  .youtube-player {
    background-color: #000;
    // margin-bottom: 30px;
    position: relative;
    padding-top: 56.25%;
    overflow: hidden;
    cursor: pointer;
  }
  .youtube-player img {
    width: 100%;
    top: -16.84%;
    left: 0;
    opacity: 0.7;
  }
  .youtube-player .play-button {
    width: 90px;
    height: 60px;
    background-color: #333;
    box-shadow: 0 0 30px rgba( 0,0,0,0.6 );
    z-index: 1;
    opacity: 0.8;
    border-radius: 6px;
  }
  .youtube-player .play-button:before {
    content: "";
    border-style: solid;
    border-width: 15px 0 15px 26.0px;
    border-color: transparent transparent transparent #fff;
  }
  .youtube-player img,
  .youtube-player .play-button {
    cursor: pointer;
  }
  .youtube-player img,
  .youtube-player iframe,
  .youtube-player .play-button,
  .youtube-player .play-button:before {
    position: absolute;
  }
  .youtube-player .play-button,
  .youtube-player .play-button:before {
    top: 50%;
    left: 50%;
    transform: translate3d( -50%, -50%, 0 );
  }
  .youtube-player iframe {
    height: 100%;
    width: 100%;
    top: 0;
    left: 0;
  }
`
