import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.addEventListener("load", () => {
      const lc = document.getElementById("loader-container");
      const loadingSlide = [ { left: 0 }, { left: "25vw", opacity: 1, offset: 0.25 }, { left: "50vw", opacity: 0.8, offset: 0.5 }, { left: "100vw", opacity: 0 } ];
      const loadingTiming = { duration: 1500, easing: "cubic-bezier(.25,.1,.25,1)" };
      const slideFinished = lc.animate(loadingSlide, loadingTiming).finished;
      slideFinished.then(() => lc.style.display = "none")
      .then(() => { const ph = document.getElementsByClassName("placeholder");while(ph.length){ph[0].classList.remove("placeholder");} });
      document.querySelector(".loading-lg").style.opacity = 0;
    });
    const c = document.getElementById("comframe");
    const cj = document.getElementById("cj");
    function jump() { !cj.dataset.controller ? cj.dataset.controller = "comjump" : c.removeEventListener("turbo:frame-load", jump);};
    c.addEventListener("turbo:frame-load", jump);
  }
}
