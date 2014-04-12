class @Calendar

  # Lade die Einträge und hänge sie an die Liste UNTEN dran
  # calendarScrollFrom und calendarScrollTo werden von dem nachgeladenen Content gesetzt
  appendEntries: ->
    @getEntries calendarNextDate, (data) ->
      $(".calendars_show .spinner").hide()
      $('.calendar-days').append(data)
      window.currentlyReloading = false

  # Hier werden die Einträge geladen und der Kalender wird komplett ersetzt
  #
  # Die Zeiten sind der Anfang des Kalenders (heute oder explizites Anfangsdatum) bis zum letzten sichtbaren Tag
  replaceEntries: ->
    @getEntries beginningOfTime, calendarScrollFrom, (data) ->
      $('.calendar-calendar').html(data)

  # Interne Funktion für den AJAX Call ;)
  getEntries: (from, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/calendar/'
      data:
        start: from
        region: regionSlug
      success: (data) ->
        callback(data)
