// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

var toggle = function(id) {
  var s = document.getElementById(id).style;
  var t = document.getElementById("headers_dump_toggle");
  if (s.display == 'none') {
    s.display = 'block';
    t.innerHTML = 'Hide headers schema';
  } else {
    s.display = 'none';
    t.innerHTML = 'Show headers schema';
  }
  return false;
}

var toggleHeadersDump = function() {
  return toggle('headers_dump');
}
