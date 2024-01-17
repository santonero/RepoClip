const media = document.querySelector("video");
media.addEventListener("loadedmetadata", () => { document.getElementById("loadcont").style.display = "none";
  function reveal() {const ph = document.getElementsByClassName("placeholder");while(ph.length){ph[0].classList.remove("placeholder");}}setTimeout(reveal, 400);});
function autoplay() {
  function mutePlay() {media.muted = true;media.play();}
  media.addEventListener("canplay", () => { const promise = media.play();
    if (promise !== undefined) promise.catch(mutePlay);});
}
document.addEventListener("DOMContentLoaded", autoplay);
