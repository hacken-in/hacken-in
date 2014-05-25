class @Calendar

  constructor: ->
    @endOfTheWorld = false
    @calendarNextDate = new Date()
    @currentlyReloading = false
    @updateLastDate($(".calendar-days"))

  updateLastDate: (element) ->
    dates = $(element).find("[data-date]")
    if dates.length == 0
      @endOfTheWorld = true
    else
      $(dates).each (i, day) =>
        date = moment($(day).attr("data-date")).add("days", 1).toDate()
        @calendarNextDate = date if date > @calendarNextDate

  loadNextEntries: ->
    return if @currentlyReloading || @endOfTheWorld
    @currentlyReloading = true
    $(".calendars_show .spinner").show()
    @getEntries @calendarNextDate, (data) =>
      node = $.parseHTML(data)
      @updateLastDate(node)
      $('.calendar-days').append($(data).children())
      $(".calendars_show .spinner").hide()
      @currentlyReloading = false

  # Interne Funktion für den AJAX Call ;)
  getEntries: (from, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/calendar/'
      data:
        start: moment(from).format("YYYY-MM-DD")
        region: regionSlug
      success: (data) ->
        callback(data)
