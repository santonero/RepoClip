import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  validate() {
    const f = document.forms[1][1];
    const ff = f.closest("div");
    const o = ff.querySelector("#old");
    const v = document.forms[1][1].value;
    if (!v) { f.classList.add("is-error"); if (o) o.remove(); ff.innerHTML += "<p class='form-input-hint d-inline' id='old'>Email can't be empty</p>"; }
  }
}
