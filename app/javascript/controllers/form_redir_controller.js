import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  next(e) {
    if (e.detail.success) {
      document.documentElement.addEventListener("turbo:before-visit", (e) => {e.preventDefault();});
      const fR = e.detail.fetchResponse;
      window.location.replace(fR.response.url);
    }
  }
}
