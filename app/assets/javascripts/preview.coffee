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
    @container = ($ base_form).find('.previewable')
    @container.find('.preview-display').hide()
    @container.find('.preview-base').show()

  transform_to_preview: (base_form) ->
    @container = ($ base_form).find('.previewable')
    preview_base = @container.find('.preview-base')
    preview_display = @container.find('.preview-display')

    if preview_display.size() == 0
      preview_display = ($ document.createElement('div'))
      .addClass('preview-display')
      .width(preview_base.width())
      .appendTo(@container)

    this.convert_to_markdown(preview_base.val())

  convert_to_markdown: (html_text) ->
    $.get '/api/markdown_converter', { text: html_text }, (markdown_data) =>
      this.show_preview(markdown_data)

  show_preview: (markdown_text)->
    preview_base = @container.find('.preview-base')
    preview_display = @container.find('.preview-display')

    preview_base.hide()
    preview_display.html(markdown_text).show()

