import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  next(e) {
    document.documentElement.addEventListener('turbo:before-visit', (e) => {e.preventDefault();});
    const fR = e.detail.fetchResponse;
    const url = fR.response.url;
    const path = url.substring(0, url.lastIndexOf('/'));
    window.location.replace(path);
  }
}
