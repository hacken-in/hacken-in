jQuery ->
  if $('body').hasClass('calendars_show')
    window.calendar = new Calendar()

    $(window).scroll ->
      if $(window).scrollTop() > $(document).height() - $(window).height() - 300
        window.calendar.loadNextEntries()

    scrollable = (selector, callback) ->
      divPos       = 0
      isDragging   = false
      wasDragging  = false
      mouseClicked = false
      clickedElement  = null
      lastPosition =
        x: 0
        y: 0

      moveDiv = (delta) ->
        return if isNaN(delta)
        containerWidth = $(selector).width()
        listWidth = $(selector + " ul").width()
        divPos += delta
        divPos = 0 if divPos > 0
        divPos = containerWidth - listWidth  if divPos < (containerWidth - listWidth)
        $(selector + " ul").css "left", divPos + "px"

      startDrag = (event) ->
        window.getSelection().removeAllRanges()
        wasDragging  = false
        isDragging   = true
        mouseClicked = true
        lastPosition.x = event.clientX
        lastPosition.y = event.clientY
        clickedElement = event.target

      dragging = (event) ->
        if isDragging
          wasDragging = true
          deltaX = event.clientX - lastPosition.x
          moveDiv deltaX
          lastPosition.x = event.clientX
          lastPosition.y = event.clientY

      stopDrag = ->
        isDragging = false
        if !wasDragging && mouseClicked
          callback(clickedElement)
        mouseClicked = false

      $(selector).on "mousewheel DOMMouseScroll", (e) ->
        e0 = e.originalEvent
        deltaX = e0.wheelDeltaX or -e0.detail
        deltaY = e0.wheelDeltaY or -e0.detail
        moveDiv deltaX / 2
        e.preventDefault()

      $(selector).on "selectstart", (evt) ->
        evt.preventDefault()
        false

      $(selector).mousedown startDrag
      $(selector).mousemove dragging
      $(selector).mouseenter stopDrag
      $(selector).mouseup stopDrag
      $(selector).on touchstart: startDrag
      $(selector).on touchend: stopDrag
      $(selector).on touchcancel: stopDrag
      $(selector).on touchleave: stopDrag
      $(selector).on touchmove: (event) ->
        dragging event.originalEvent.touches.item(0)
        event.originalEvent.preventDefault()

      itemWidth = $("li", selector).outerWidth(true)
      $("ul", selector).css("width", (itemWidth * $("li", selector).length) + "px")

    initScrollableMonths = ->
      scrollable ".calendar-startselector nav.months", (element) ->
        date = $(element).attr("data-date")
        if date
          $(".calendar-startselector nav.months .active").removeClass("active")
          $(element).addClass("active")
          selectedDate = moment(date).toDate()
          window.calendar.updateDaySelector(
            selectedDate,
            -> initScrollableDays()
          )
          window.calendar.scrollToDate(selectedDate, true)

    initScrollableDays = ->
      scrollable ".calendar-startselector nav.days", (element) ->
        date = $(element).parent().attr("data-date")
        if date
          $(".calendar-startselector nav.days .active").removeClass("active")
          $(element).parent().addClass("active")
          window.calendar.scrollToDate(moment(date).toDate())

    initScrollableMonths()
    initScrollableDays()
