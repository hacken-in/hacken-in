jQuery ->
  if $('body').hasClass('calendars_show')
    $(document).on 'mouseenter', '.calendar-line', ->
      $(this).css('background-color', $(this).data('hlcolor')).addClass('calendar-line-highlighted')

    $(document).on 'mouseleave', '.calendar-line', ->
      $(this).css('background-color', '#000').removeClass('calendar-line-highlighted')

    $('.js-kddk-preset').on 'click', CalendarPreset.switchPreset

    $('.js-like-tag-button').on 'click', ->
      CalendarTaggings.addTag('like')

    $('.js-like-tag-text').on 'keyup', (event) ->
      CalendarTaggings.addTag('like') if event.keyCode is 13 or event.which is 13
    
    $('.js-hate-tag-button').on 'click', ->
      CalendarTaggings.addTag('hate')

    $('.js-hate-tag-text').on 'keyup', (event) ->
      CalendarTaggings.addTag('hate') if event.keyCode is 13 or event.which is 13
    

    $(document).on 'click', '.js-remove-tag', ->
      data = $(this).parent().data()
      $(this).parent().remove()
      CalendarTaggings.removeTag(data.list, data.tag)

    # Laden wir mal die DIY Kategorie
    CalendarPreset.selectCategoriesFromPreset('diy')

    ###
    # Und dann noch das infinite scroll
    $(window).endlessScroll
      fireDelay: 200
      fireOnce: true
      inflowPixels: 500
      ceaseFireOnEmpty: false
      loader: '<div class="loading"><div>',
      callback: (fireSequence, pageSequence, scrollDirection)->
        if scrollDirection == 'next'
          $.ajax
            url: "/calendar/entries"
            type: 'GET'
            data: "from=#{calendarScrollFrom}&to=#{calendarScrollTo}"
            success: (data)->
            #  $('.calendar-calendar').append(data)
    ###


CalendarTaggings =
  addTag: (list) ->
    tag = $(".js-#{list}-tag-text").val()
    $(".js-#{list}-taglist").append "<li data-tag=\"#{tag}\" data-list=\"#{list}\">#{tag} <i class=\"icon-remove remove-tag js-remove-tag\"></li>"
    $(".js-#{list}-tag-text").val('')

    $.ajax
       type: 'POST'
       url: "/user/#{list}"
       data:
         tags: [tag]
       success: (data) ->
         if data.status is 'error'
           # TODO: Eventuell ein schöneres Alert
           alert "Da ging wat schief: #{data.message}"
  
   # TODO: Kalender filtern

  removeTag: (list, tag) ->
    console.log "I no longer #{list} #{tag}"
    
    $.ajax
       type: 'DELETE'
       url: "/user/#{list}/#{tag}"
       success: (data) ->
         if data.status is 'error'
           # TODO: Eventuell ein schöneres Alert
           alert "Da ging wat schief: #{data.message}"
  

    # TODO: Kalender filtern
  
CalendarPreset =
  switchPreset: ->
    presetId = $(this).data('preset')

    # Reset active tab
    $('.js-kddk-preset').removeClass('active')
    $(this).addClass('active')

    CalendarPreset.selectCategoriesFromPreset(presetId)
    # TODO: Save the the user preset

  selectCategoriesFromPreset: (presetId) ->
    $all_checkboxes = $('input[name=calendar_category]')

    if presetId
      presetId = presetId.toString()
    else
      presetId = 'diy'

    $all_checkboxes.attr 'disabled', (presetId != 'diy')

    if presetId == 'diy' and calendarPresets[presetId].length == 0
      $all_checkboxes.attr('checked', true)
    else
      $all_checkboxes.attr('checked', false)

      $.each calendarPresets[presetId], (id, categoryId)->
        $('input[name=calendar_category][value=' + categoryId + ']').attr('checked', true)
