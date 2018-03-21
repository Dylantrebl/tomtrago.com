function setFilterColor(hex) {
  let el = document.querySelector('.filter');
  el.style.backgroundColor = hex;
}

function sectionStartVisible(target){
  let name = target.dataset.sectionName;
  let menuItems = document.querySelectorAll('ul.navigation-menu li');
  menuItems.forEach(function (li) {
    if (li.dataset.sectionName !== name) {
      console.log("remove" + li);
      li.classList.remove('active');
    } else {
      li.classList.add('active');
      console.log(li);
    }
  });
};


function handleObserverCallback(entries, observer) {
  entries.forEach(function (entry) {
    if (entry) {
      sectionStartVisible(entry.target);
    }
  });
}

function setupObserver() {
  let observer = new IntersectionObserver(handleObserverCallback, { threshold: 0.2, });
  let sections = document.querySelectorAll('.main-content section');
  sections.forEach(function (section) {
    observer.observe(section);
  });
}

window.addEventListener('load', setupObserver);


let startIndex = 0;
let endIndex = 4;

setInterval(function () {
  let idx = Math.ceil(Math.random() * (endIndex - startIndex));
  let body = document.querySelector('body');
  let img = new Image();
  let imgUrl = "/bg/bg"  + idx + ".jpg";
  img.addEventListener('load', function() {
    body.style.backgroundImage = "url('" + imgUrl + "')";
  });
  img.src = imgUrl;

}, 10000
);
