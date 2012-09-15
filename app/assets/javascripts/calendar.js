// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  $('.calendar-line').on('mouseenter', function() {
    $(this).animate({'background-color': $(this).data('hlcolor')}).addClass('calendar-line-highlighted');
  });

  $('.calendar-line').on('mouseleave', function() {
    $(this).css({'background-color': '#000'}).removeClass('calendar-line-highlighted');
  });
});