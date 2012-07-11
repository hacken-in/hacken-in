window.registerPreviewHook = (identifier) ->
  ($ 'a.show-preview').click (event) ->
    event.preventDefault()
    showPreview identifier

showPreview = (identifier) ->
  ($ identifier).keyup ->
    updatePreview identifier

  if ($ '.markdown-preview').is ':hidden'
    ($ '.markdown-preview').slideDown()
  else
    ($ '.markdown-preview').slideUp()

  ($ identifier).keyup()

updatePreview = (identifier) ->
  comment_text = ($ identifier).val()
  converter = new Showdown.converter()
  generated_html = converter.makeHtml comment_text
  ($ '.markdown-preview').html generated_html
