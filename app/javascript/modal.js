function hideModal() {
  const e=document.getElementById("mod");e.classList.remove("active");
  const s=document.getElementsByClassName("shakeit");if(s) while(s.length){s[0].classList.remove("shakeit");}
  const media=document.querySelector("video");
  if(media && !media.ended)media.play();
}

function validateSize(input, size, target) {
  const fileSize = input.files[0].size / 1024 / 1024;
  const t = document.getElementById(target);
  const ff = t.closest("div");
  const o = document.getElementById("old");
  if (fileSize > size) {
    ff.classList.add("has-error");
    if(o) o.remove();
    t.classList.add("shakeit");
    if (ff.nextElementSibling) ff.nextElementSibling.remove();
    ff.innerHTML += `<p class='form-input-hint d-inline' id='old'>${capitalize(target.split('_')[1])} should be less than ${size}MB</p>`;}
  else { if(o) o.remove();
    ff.classList.remove("has-error");
    t.classList.remove("shakeit");}
  function capitalize(s) {
  return s.charAt(0).toUpperCase() + s.slice(1);}
}
