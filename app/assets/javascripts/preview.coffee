
$ ->
  $('.preview .show-comment').click (event)->
    event.preventDefault()

    return if ($ this).hasClass('disabled')

    new HckingPreview().hide_preview(($ this).parents('form'))
    ($ this).addClass('disabled')
    ($ this).siblings('.show-preview').removeClass('disabled')

  $('.preview .show-preview').click (event)->
    event.preventDefault()

    return if ($ this).hasClass('disabled')

    new HckingPreview().transform_to_preview(($ this).parents('form'))
    ($ this).addClass('disabled')
    ($ this).siblings('.show-comment').removeClass('disabled')

HckingPreview = ->
  hide_preview: (base_form) ->
    container = ($ base_form).find('.previewable')
    container.find('.preview-display').hide()
    container.find('.preview-base').show()

  transform_to_preview: (base_form) ->
    container = ($ base_form).find('.previewable')
    preview_base = container.find('.preview-base')
    preview_display = container.find('.preview-display')

    if preview_display.size() == 0
      preview_display = ($ document.createElement('div'))
      .addClass('preview-display')
      .width(preview_base.width())
      .appendTo(container)

    markdown = this.convert_to_markdown(preview_base.val())
    preview_base.hide()
    preview_display.html(markdown).show()

  convert_to_markdown: (html_text) ->
    converter = new Showdown.converter()
    converter.makeHtml(html_text)


