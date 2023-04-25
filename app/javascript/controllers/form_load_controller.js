import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  showload() {
    let t = setTimeout(() => { document.getElementById('formload').classList.add('loading'); }, 200)
    document.getElementById('vidform').addEventListener('turbo:submit-end', () => {
        clearTimeout(t);
    })
  }
}
