$ ->
  if $(".admin_single_events.edit,.admin_single_events.new").length > 0
    $('.chosen-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'
