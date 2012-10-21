jQuery ->
  if $('body').hasClass('calendars_show')
    $(document).on 'mouseenter', '.calendar-line', ->
      $(this).css('background-color', $(this).data('hlcolor')).addClass('calendar-line-highlighted')

    $(document).on 'mouseleave', '.calendar-line', ->
      $(this).css('background-color', '#000').removeClass('calendar-line-highlighted')

    $('.js-kddk-preset').on 'click', CalendarPreset.switchPreset

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
