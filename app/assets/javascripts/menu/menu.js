$(document).ready(function(){
  $('.navigation-menu li a').each(function () {
    console.log($(this));

    $(this).on("touchstart", function () {
      $(this).addClass('.fake-hover');
    });
    $(this).on("touchend", function(){
      $(this).removeClass('.fake-hover');
    });
    $(this).on("touchcancel", function(){
      $(this).removeClass('.fake-hover');
    });
  });
});

function handleHrefClick(e, href) {
  showPopup(href);
  return true;
}

function showPopup(href) {
  if (window.showing) window.showing.classList.remove('show');
  if (window.selectedLink) window.selectedLink.classList.remove('active');
  var mainmenu = document.querySelector('.navigation-menu');
  mainmenu.classList.add('hide');
  var a = document.querySelector('li.' + href + ' a');
  a.classList.add('active');
  window.selectedLink = a;
  var maincontent = document.querySelector('.main-content');
  maincontent.classList.add('show');
  var section = document.querySelector('.content-section.' + href);
  section.classList.add('show');
  $(section).scrollTop(0);
  window.showing = section;
}

function resetPopup() {
  var mainmenu = document.querySelector('.navigation-menu');
  mainmenu.classList.remove('hide');
  var maincontent = document.querySelector('.main-content');
  maincontent.classList.remove('show');
  if (window.showing) window.showing.classList.remove('show');
  if (window.selectedLink) window.selectedLink.classList.remove('active');
}

var startIndex = 1;
var endIndex = 10;

if (window.matchMedia('(min-width: 550px)').matches) {

  setInterval(function () {
    var idx = Math.ceil(Math.random() * (endIndex - startIndex));
    var body = document.querySelector('.background');
    var img = new Image();
    var imgUrl = "/bg/bg"  + idx + ".jpg";
    img.addEventListener('load', function() {
      body.style.backgroundImage = "url('" + imgUrl + "')";
    });
    img.src = imgUrl;

  }, 15000
);
}
