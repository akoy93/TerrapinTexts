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
//= require bootstrap
//= require_tree .

$(function() {
  $("#buy_search").submit(function() {
    $.get($("#buy_search").attr("action"), $("#buy_search").serialize(), null, "script");
    return false;
  });

  $("#textbook_listing_isbn").focusout(function() {
    $.get($(this).attr("action"), $(this).serialize(), null, "script");
    return false;
  });

  $("#new_textbook_listing").submit(function() {
    $.get($(this).attr("action"), $(this).serialize(), null, "script");
    return false;
  });

  $("button.close").click(function() {
    alert($(this).attr("id"));
    return false;
  });
});
