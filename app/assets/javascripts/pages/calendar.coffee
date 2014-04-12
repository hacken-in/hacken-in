jQuery ->
  if $('body').hasClass('calendars_show')
    window.calendar = new Calendar()

    $(window).scroll ->

      if $(window).scrollTop() > $(document).height() - $(window).height() - 300 and not window.currentlyReloading and not window.endOfTheWorld
        window.currentlyReloading = true
        window.calendar.appendEntries()
        $(".calendars_show .spinner").show()

    scrollable = (selector) ->
      divPos = 0
      isDragging = false
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
        isDragging = true
        lastPosition.x = event.clientX
        lastPosition.y = event.clientY

      dragging = (event) ->
        if isDragging
          deltaX = event.clientX - lastPosition.x
          moveDiv deltaX
          lastPosition.x = event.clientX
          lastPosition.y = event.clientY

      stopDrag = ->
        isDragging = false

      $(selector).bind "mousewheel DOMMouseScroll", (e) ->
        e0 = e.originalEvent
        deltaX = e0.wheelDeltaX or -e0.detail
        deltaY = e0.wheelDeltaY or -e0.detail
        moveDiv deltaX / 2
        e.preventDefault()

      $(selector).bind "selectstart", (evt) ->
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


    scrollable ".calendar-startselector nav.months"
    scrollable ".calendar-startselector nav.days"
