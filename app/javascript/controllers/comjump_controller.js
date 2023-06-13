import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const c = document.getElementById('comframe');
    c.addEventListener('turbo:before-frame-render', () => {
      const cc = document.getElementById('ccount');
      if(cc) cc.scrollIntoView();});
  }
}
