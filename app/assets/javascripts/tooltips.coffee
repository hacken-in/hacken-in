$ ->
  ($ '.gravatar_tooltip').tipsy gravity: 'nw'

  ($ '.tags li a').each (index, anchor) ->
    ($ anchor).balloon
      css:
        background: 'rgba(0, 0, 0, 0.9)'
        color: '#fff'
      contents: ($ anchor).siblings('.tag_layer').html()
