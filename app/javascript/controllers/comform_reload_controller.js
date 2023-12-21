import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const cf = document.getElementById("comframe");
    const src = cf.src;
    const form = document.getElementById("comform");
    const formErrors = form.getElementsByClassName("slidev");
    const hasError = form.getElementsByClassName("has-error");
    let url = new URL(src);
    url.search = "page=1";
    cf.src = url;
    form.reset();
    if(formErrors.length) while(formErrors.length){formErrors[0].remove();}
    if(hasError.length) while(hasError.length){hasError[0].classList.remove("has-error");}
  }
}
