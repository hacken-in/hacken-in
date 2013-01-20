$ ->
  $.balloon.defaults.css = null # don't use balloon's CSS

  # Scroll to the active day, which is 'today' on pageload:
  ($ '.minical').scrollTo('50%')

  # Tooltips on event hover
  $('[data-behavior=event-tooltip--trigger]').each (index, cell) ->
    $cell = $(cell)
    $cell.balloon
      css:
        opacity: 1.0 # for some reason, at least on css property needs to be defined
      classname: 'm-event-tooltip'
      hideDuration: 0
      minLifetime: 50
      showDuration: 50
      contents: $cell.siblings("[data-behavior=event-tooltip--content][data-event_id=#{$cell.data('event-id')}]").html()