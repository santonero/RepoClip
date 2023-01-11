import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var media = document.querySelector('video');
    media.addEventListener('canplaythrough', (event) => { media.play();});
  }
}
