$ ->
  ($ '.gravatar_tooltip').tipsy gravity: 'nw'

  ($ '.tags li a').each (index, anchor) ->
    ($ anchor).balloon
      css:
        opacity: 0.9
        color: '#000'
      contents: ($ anchor).siblings('.tag_layer').html()
