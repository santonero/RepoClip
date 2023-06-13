import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const hid = document.querySelectorAll('.hidden');
    for(let i=0;i<hid.length;i++) {
      hid[i].querySelector('img').onload = function () {
        let c = hid[i].querySelector('img').closest('.card');
        let ph = c.querySelectorAll('.placeholder');
        for(let i=0; i<ph.length; i++) {
          ph[i].classList.remove('placeholder');}
        hid[i].classList.remove('hidden');};
    }
  }
}
