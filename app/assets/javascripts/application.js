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
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require bootstrap-datepicker

var runningRequest = false;
var request;
var keyCounter = 0;

function handle_new_textbook_listing() {
  $("#new_textbook_listing").submit(function() {
    $.get($(this).attr("action"), $(this).serialize(), null, "script");
    return false;
  });
}

function handle_textbook_listing_isbn() {
  $("#textbook_listing_isbn").focusout(function() {
    $.get($(this).attr("action"), $(this).serialize(), null, "script");
    return false;
  });
}

function copyText (text) {
  window.prompt ("Copy email to clipboard: Ctrl+C, Enter", text);
}

function add_datepicker() {
  $("[data-behaviour~='datepicker']").datepicker({
    "format": "yyyy-mm-dd",
    "weekStart": 1,
    "autoclose": true
  });
}

$(function() {
  $('#buy_search').keyup(function(e) {
    keyCounter++;
    //if (keyCounter % 3 == 0 || e.which == 8){
      e.preventDefault();

      if (runningRequest) {
        request.abort();
      }

      runningRequest = true;
      request = $.get($("#buy_search").attr("action"), $("#buy_search").serialize(), function(data) {
        runningRequest = false;
      }, "script");
    //}
  });

  $("#buy_search").submit(function() {
    $.get($("#buy_search").attr("action"), $("#buy_search").serialize(), null, "script");
    return false;
  });

  // ajax pagination
  $("#paginator a").live("click", function() {
    $.getScript(this.href);
    return false;
  });

  // preserve search when sorting
  $("#listings tr th a").live("click", function() {
    $.getScript(this.href);
    return false;
  });

  // copy email to clipboard
  $('.email').live("click", function(e) {
    e.preventDefault();
    copyText($(this).attr('id'));
  });

  // filter by friends ajax
  $('input:checkbox').live('change', function(){
    $.get($("#buy_search").attr("action"), $("#buy_search").serialize(), null, "script");
    return false;
  });

  // links open in new window/tab
  $('.new-window').live('click', function(e) {
    e.preventDefault();
    window.open($(this).attr('href'));
  });
  
  handle_textbook_listing_isbn();
  handle_new_textbook_listing();
  add_datepicker();
});
