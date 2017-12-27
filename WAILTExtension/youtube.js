function getVideo() {
  return document.querySelector('#movie_player video');
}
function getTitleEl() {
  return document.querySelector('#info-contents .title');
}
function validPage() {
  return window.location.href.startsWith('https://www.youtube.com/watch?')
}

document.addEventListener('yt-navigate-start', function() {
  console.log('yt-nav-st')
  pageChanged()
});
document.addEventListener('yt-navigate-finish', function() {
  console.log('yt-nav-fin')
  pageChanged()
});