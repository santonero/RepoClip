import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const c = document.getElementById("comframe");
    const cj = document.getElementById("cj");
    function jump() { !cj.dataset.controller ? cj.dataset.controller = "comjump" : c.removeEventListener("turbo:frame-load", jump); }
    c.addEventListener("turbo:frame-load", jump);
  }
}
