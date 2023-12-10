import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const c = document.getElementById("comframe");
    const va = document.getElementById("vidact");
    c.addEventListener("turbo:before-frame-render", () => {if(va) va.scrollIntoView();});
  }
}
