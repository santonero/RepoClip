import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const scrolL = () => { document.documentElement.scrollTop>= 200 ? document.getElementById('up').style.display = 'block' : document.getElementById('up').style.display = 'none';};
    window.addEventListener('scroll',scrolL);
    const tVisit = () => { window.removeEventListener('scroll', scrolL);document.documentElement.removeEventListener('turbo:visit',tVisit);};
    document.documentElement.addEventListener('turbo:visit',tVisit);
  }
}
