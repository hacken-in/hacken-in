$(->
  updateSingleEvent = ->
    fullDay = $('#single_event_full_day').is(':checked')
    $('#single_event_duration').prop('disabled', fullDay)
    if (fullDay)
      $('#single_event_occurrence_4i').hide()
      $('#single_event_occurrence_5i').hide()
    else
      $('#single_event_occurrence_4i').show()
      $('#single_event_occurrence_5i').show()

  if $('#single_event_full_day')
    $('#single_event_full_day').change(->
      updateSingleEvent()
    )
    updateSingleEvent()
)
