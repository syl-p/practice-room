import styles from "./youtube_player.style"
export class YoutubePlayer extends HTMLElement {
    static get observedAttributes() { return ['video-id'] }

    constructor() {
        super()
        this.shadow = this.attachShadow({mode: 'closed'})
    }

    connectedCallback() {
        this.setUpPlayer()
    }

    disconnectedCallback() {

    }

    attributeChangedCallback(name, oldValue, newValue) {
        this.setUpPlayer()
    }

    setUpPlayer() {
        if(this.getAttribute('video-id') && this.getAttribute('video-id') !== '') {
            this.shadow.innerHTML = `
                <style>${styles}</style>
                <div class="youtube-player" data-embed="${this.getAttribute('video-id')}">
                    <div class="play-button"></div>
                </div>
            `
            // GET THE TUMBNAIL
            const source = "https://img.youtube.com/vi/"+ this.getAttribute('video-id') +"/sddefault.jpg";
            const image  = new Image();
            image.src = source;
            image.addEventListener( "load", () => {
                this.shadow.querySelector('.youtube-player').appendChild( image );
            });

            // CLICK EVENT
            this.shadow.addEventListener( "click", () => {
                const iframe = document.createElement( "iframe" );

                iframe.setAttribute( "frameborder", "0" );
                iframe.setAttribute( "allowfullscreen", "" );
                iframe.setAttribute( "src", "https://www.youtube.com/embed/"+ this.getAttribute('video-id') +"?rel=0&showinfo=0&autoplay=1" );

                this.shadow.querySelector('.youtube-player').innerHTML = "";
                this.shadow.querySelector('.youtube-player').appendChild( iframe );
            });
        } else {
          this.shadow.innerHTML = `
            <style>${styles}</style>
            <div class="no-video">
              <p>Aucune vidéo par defaut n'a été définie pour cette exercice.</p>
            </div>
          `
        }
    }
}
