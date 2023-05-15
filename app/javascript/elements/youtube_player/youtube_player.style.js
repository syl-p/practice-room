export default `
  .youtube-player {
    position: relative;
    width: 100%;
    height: 0;
    padding-bottom: 56.25%; /* aspect ratio 16:9 */
    overflow: hidden;
    cursor: pointer;
    border-radius: 1.5rem;
  }

  .youtube-player img {
    object-fit: cover;
  }

  .youtube-player img,
  .youtube-player iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .youtube-player .play-button {
    width: 80px;
    height: 80px;
    background-color: #333;
    border-radius: 50%;
    box-shadow: 0 0 30px rgba( 0, 0, 0, 0.6 );
    z-index: 1;
    opacity: 0.8;
    transition: all 0.2s;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate( -50%, -50% );
  }

  .youtube-player .play-button:before {
    content: "";
    border-style: solid;
    border-width: 15px 0 15px 26.0px;
    border-color: transparent transparent transparent #fff;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate( -50%, -50% );
  }

  .youtube-player:hover .play-button {
    opacity: 1;
  }
`
