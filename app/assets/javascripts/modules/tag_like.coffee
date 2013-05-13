$(->

  addTag = (action, tag) ->
    $.ajax
       type: 'POST'
       url: "/api/user/#{action}"
       data:
         tags: [tag]
       success: (data) ->
         if data.status is 'error'
           # TODO: Eventuell ein schöneres Alert
           alert "Da ging wat schief: #{data.message}"

  $(document).on "click", ".m-tag-love-click", ->
    addTag("like", $(this).attr("data-tag-name"))
    $(this).parent().hide()
    return false

  $(document).on "click", ".m-tag-hate-click", ->
    addTag("hate", $(this).attr("data-tag-name"))
    $(this).parent().hide()
    return false

  $('.tag_entry').each (index, cell) ->

    generateHtmlForPopup = ->
      console.log $(cell).attr("data-tag-id")
      "<a href='#' class='m-tag-love-click' data-tag-id='#{$(cell).attr("data-tag-id")}' data-tag-name='#{$(cell).attr("data-tag-name")}'><img class='m-tag-love' src='/assets/tag_love.png' alt='Hashtag lieben'/></a>"+
      "<a href='#' class='m-tag-hate-click' data-tag-id='#{$(cell).attr("data-tag-id")}' data-tag-name='#{$(cell).attr("data-tag-name")}'><img class='m-tag-hate' src='/assets/tag_hate.png' alt='Hashtag boykotieren'/></a>"
    $cell = $(cell)
    $cell.balloon
      css:
        opacity: 1.0 # for some reason, at least on css property needs to be defined
      classname: 'm-tag-popup'
      hideDuration: 0
      minLifetime: 50
      showDuration: 50
      contents: generateHtmlForPopup()
      tipSize: 0
)
