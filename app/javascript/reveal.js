function reveal() { document.getElementById("vidfoot").style.display = "block";document.getElementById("comcont").style.display = "block";document.querySelector(".docs-footer").style.display = "block";function rev() {const ph = document.getElementsByClassName("placeholder");while(ph.length){ph[0].classList.remove("placeholder");}}setTimeout(rev, 700);}
window.addEventListener("load", reveal);
