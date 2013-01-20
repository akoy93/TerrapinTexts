# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#q_title_or_author_or_isbn_or_course_cont").autocomplete
    source: "/search_suggestions"
    minLength: 1
    select: (event, ui) ->
      $(this).val ui.item.label
      $("#buy_search").submit()

# adjust maximum number of terms in search_suggestions model
