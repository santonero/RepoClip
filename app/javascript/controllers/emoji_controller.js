import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    event.stopPropagation();
    event.preventDefault();
    const pickerOptions = { onEmojiSelect: pickit, onClickOutside: rm, theme: "light", dynamicWidth: "true" };
    const picker = new EmojiMart.Picker(pickerOptions);
    const ca = document.getElementById("comarea");
    function pickit(e) { document.getElementById("comment_body").value += e.native; }
    function rm() { document.querySelector("em-emoji-picker").remove(); ca.classList.remove("active");}
    if (ca.classList.contains("active")) {
      document.querySelector("em-emoji-picker").remove();
      ca.classList.remove("active");}
    else {
      ca.classList.add("active");
      ca.appendChild(picker);
      const em = document.querySelector("em-emoji-picker");
      em.shadowRoot.styleSheets[0].cssRules[1].style.setProperty("--em-rgb-accent","66,64,212");}
  }
}
