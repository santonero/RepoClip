import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(e) {
    const l = document.querySelector("#login");
    if (l.classList.contains("active")) {
      l.firstElementChild.remove();
      l.classList.remove("active");
      e.preventDefault(); }
    else { l.classList.add("active"); }
  }
}
