$ ->
  # Scroll to the active day, which is 'today' on pageload:
  ($ '.minical').scrollTo('50%')

  # Tooltips on event hover
  ($ '.minical .minical-cell.non-empty').each (index, cell) ->
    ($ cell).balloon
      css:
        opacity: 1.0
        color: '#fff'
        backgroundColor: 'rgba(0, 0, 0, 0.8)'
        padding: '15px'
        border: 'none'
        borderRadius: '0'
        boxShadow: '0'
      hideDuration: 0
      minLifetime: 50
      showDuration: 50
      contents: ($ cell).find('.cell-content').html()
