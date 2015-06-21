$ ->

  resizeWindow = ->
    height = $("body").height() - $("header").height() - $(".welcome_map .description").outerHeight()
    $("#german_map").css("height", "#{height}px")

  initMap = ->
    map = L.map('german_map', {closePopupOnClick: false})

    # add an OpenStreetMap tile layer
    L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="//www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map)

    koeln = new L.Popup()
    koeln.setLatLng([50.938056,6.956944])
    koeln.setContent("<a href='/move_to/koeln'>Köln</a>")
    map.addLayer(koeln)

    berlin = new L.Popup()
    berlin.setLatLng([52.516667,13.383333])
    berlin.setContent("<a href='/move_to/berlin'>Berlin</a>")
    map.addLayer(berlin)

    muenchen = new L.Popup()
    muenchen.setLatLng([48.1368,11.5781])
    muenchen.setContent("<a href='/move_to/muenchen'>München</a>")
    map.addLayer(muenchen)

    ruhrgebiet = new L.Popup()
    ruhrgebiet.setLatLng([51.45564,7.01156])
    ruhrgebiet.setContent("<a href='/move_to/ruhrgebiet'>Ruhrgebiet</a>")
    map.addLayer(ruhrgebiet)

    map.fitBounds([
      [50.938056,6.956944],
      [52.516667,13.383333],
      [48.1368,11.5781],
      [51.45564,7.01156]
    ], {padding: [50, 50]})

  if $(".welcome_map").length > 0
    resizeWindow()
    $(window).resize(resizeWindow)
    initMap()
