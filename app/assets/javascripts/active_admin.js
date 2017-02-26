//= require moment
//= require moment/de.js
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require chosen-jquery

//= require admin/events/form
//= require_self

$(function() {
  $(".chosen-select").chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched'
  });
});
