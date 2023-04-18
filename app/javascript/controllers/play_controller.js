import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const media = document.querySelector('video');
    media.addEventListener('canplaythrough', (event) => { media.play();});
  }
}
