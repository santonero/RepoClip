import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const cf = document.getElementById('comframe');
    const src = cf.src;
    let url = new URL(src);
    url.search = 'page=1';
    cf.src = url;
  }
}
