import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const media = document.querySelector('video');
    function mutePlay() {media.muted = true;media.play();}
    media.addEventListener('canplay', () => { const promise = media.play();
      if (promise !== undefined) promise.catch(mutePlay);});
  }
}
