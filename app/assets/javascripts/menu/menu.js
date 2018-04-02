function handleHrefClick(e, href) {
  showPopup(href);
  return true;
}

function showPopup(href) {
  if (window.showing) window.showing.classList.remove('show');
  if (window.selectedLink) window.selectedLink.classList.remove('active');
  let mainmenu = document.querySelector('.navigation-menu');
  mainmenu.classList.add('hide');
  let a = document.querySelector('li.' + href + ' a');
  a.classList.add('active');
  window.selectedLink = a;
  let maincontent = document.querySelector('.main-content');
  maincontent.classList.add('show');
  let section = document.querySelector('.content-section.' + href);
  section.classList.add('show');
  window.showing = section;
}

function resetPopup() {
  let mainmenu = document.querySelector('.navigation-menu');
  mainmenu.classList.remove('hide');
  let maincontent = document.querySelector('.main-content');
  maincontent.classList.remove('show');
  window.showing.classList.remove('show');
}

let startIndex = 1;
let endIndex = 10;

setInterval(function () {
  let idx = Math.ceil(Math.random() * (endIndex - startIndex));
  let body = document.querySelector('body');
  let img = new Image();
  let imgUrl = "/bg/bg"  + idx + ".jpg";
  img.addEventListener('load', function() {
    body.style.backgroundImage = "url('" + imgUrl + "')";
  });
  img.src = imgUrl;

}, 15000
);
