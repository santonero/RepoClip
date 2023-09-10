import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const c = document.getElementById('comframe');
    c.addEventListener('turbo:before-frame-render', () => {
      const va = document.getElementById('vidact');
      if(va) va.scrollIntoView();});
  }
}
