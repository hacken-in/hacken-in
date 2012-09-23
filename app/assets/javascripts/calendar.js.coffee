jQuery ->
  if $('.calendars_show').length > 0
    $('.calendar-line').on 'mouseenter', ->
      $(this).css('background-color', $(this).data('hlcolor')).addClass('calendar-line-highlighted')

    $('.calendar-line').on 'mouseleave', ->
      $(this).css('background-color', '#000').removeClass('calendar-line-highlighted')

    $('.calendar-categories-tabs li a').on 'click', CalendarPreset.switchPreset ;

    # Laden wir mal die DIY Kategorie
    CalendarPreset.selectCategoriesFromPreset('diy');


CalendarPreset =
  switchPreset: ->
    presetId = $(this).attr('preset')

    # Reset active tab
    $('.calendar-categories-tabs li').removeClass('active')
    $(this).parent().addClass('active')

    CalendarPreset.selectCategoriesFromPreset(presetId)

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