class @Calendar

  constructor: ->
    @endOfThePage = false
    @calendarNextDate = new Date()
    @calendarFirstDate = null
    @currentlyReloading = false
    @updateLastDate($(".calendar-days"))

  updateLastDate: (element) ->
    dates = $(element).find("[data-date]")
    if dates.length == 0
      @endOfThePage = true
    else
      $(dates).each (i, day) =>
        date = moment($(day).attr("data-date")).add("days", 1).toDate()
        @calendarNextDate = date if date > @calendarNextDate
        @calendarFirstDate = date if @calendarFirstDate == null || date < @calendarFirstDate

  scrollToDate: (date, forceReset) ->
    forceReset = false if forceReset == null || forceReset == undefined
    if !forceReset && (date >= @calendarFirstDate && date < @calendarNextDate)
      lastElement = null
      parsedDate = moment(date).toDate()
      $(".calendar-days *[data-date]").each (i, element) ->
        curDate = moment($(element).attr("data-date")).toDate()
        if lastElement? && curDate > parsedDate
          lastElement.scrollIntoView()
          return false

        lastElement = element
    else
      @resetCalendar(date)

  resetCalendar: (date) ->
    return if @currentlyReloading
    @endOfThePage = false
    @calendarFirstDate = date
    @calendarNextDate = date
    $(".calendar-days").empty()
    @loadNextEntries()

  loadNextEntries: ->
    return if @currentlyReloading || @endOfThePage
    @currentlyReloading = true
    $(".calendars_show .spinner").show()
    @getEntries @calendarNextDate, (data) =>
      node = $.parseHTML(data)
      @updateLastDate(node)
      $('.calendar-days').append($(data).children())
      $(".calendars_show .spinner").hide()
      @currentlyReloading = false

  getEntries: (from, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/calendar/entries'
      data:
        start: moment(from).format("YYYY-MM-DD")
        region: regionSlug
      success: (data) ->
        callback(data)

  updateDaySelector: (start_date, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/calendar/selector'
      data:
        start: moment(start_date).format("YYYY-MM-DD")
      success: (data) ->
        $(".calendar-startselector nav.days").replaceWith(data)
        callback()

