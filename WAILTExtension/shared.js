"use strict";

// 'hacky' solution to pushState and popState not firing events (adapted from https://stackoverflow.com/a/41825103)
var pushState = history.pushState;
history.pushState = function () {
  console.log('wooo');
  pushState.apply(history, arguments);
  pageChanged()
};
var popState = history.popState;
history.popState = function () {
  console.log('wheee');
  popState.apply(history, arguments);
  pageChanged()
};

// UUID generator (taken from https://stackoverflow.com/a/2117523)
function uuidv4() {
  return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
    (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
  );
};


let fakeVid = {fake: true, currentTime: 0, duration: 0};
let fakeTitle = {fake: true, innerText: "(null)"};

let uid = uuidv4();
var vid = fakeVid;
var titleEl = fakeTitle;

function ensureElements() {
  if (vid.fake === true) {
    var v = getVideo()
    if (v != null) {
      vid = v;
      processVid(vid)
    }
  }
  if (titleEl.fake === true) {
    titleEl = getTitleEl() || titleEl;
  }
}

function processVid(v) {
  vid.addEventListener('durationchanged', function() { sendMsg('durationChanged'); });
  vid.addEventListener('timeupdate',      function() { sendMsg('timeUpdate');      });
  
  vid.addEventListener('ended', function() { sendMsg('ended'); });
  
  vid.addEventListener('pause', function() { sendMsg('pause'); });
  vid.addEventListener('play',  function() { sendMsg('play');  });
  
  vid.addEventListener('waiting', function() { sendMsg('pause.buffer'); });
  vid.addEventListener('playing', function() { sendMsg('play.buffer');  });
}

function sendMsg(msg) {
  if (!validPage()) return;
  
  ensureElements();
  
  var obj = {};
  obj.uid = uid;
  obj.title = titleEl.innerText;
  obj.currentTime = vid.currentTime;
  obj.duration = vid.duration;
  safari.extension.dispatchMessage(msg, obj);
}

function pageChanged() {
  vid = fakeVid;
  titleEl = fakeTitle;
  sendMsg('page changed');
}

document.addEventListener("DOMContentLoaded", function(event) {
  console.log('WAILT Initalizing...');
  ensureElements();
  
  sendMsg('page loaded');
  console.log('WAILT Loaded');
});

// safari.self.addEventListener('message', function(evt) {
//   if (evt.name === 'go') {
//     console.log(new Date(), 'updating...');
//     sendMsg('update');
//   }
// });
