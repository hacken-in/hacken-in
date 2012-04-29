$(->
  updateEvent = ->
    fullDay = $('#event_full_day').is(':checked')
    $('#event_duration').prop('disabled', fullDay)
    if (fullDay)
      $('#event_start_time_4i').hide()
      $('#event_start_time_5i').hide()
    else
      $('#event_start_time_4i').show()
      $('#event_start_time_5i').show()

  if $('#event_full_day')
    $('#event_full_day').change(->
      updateEvent()
    )
    updateEvent()
)

