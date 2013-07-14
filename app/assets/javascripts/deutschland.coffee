$ ->
  if $(".welcome_deutschland").length > 0
    # create a map in the "map" div, set the view to a given place and zoom
    map = L.map('german_map', {closePopupOnClick: false}).setView([51.72,10.165], 7)

    # add an OpenStreetMap tile layer
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map)

    koeln = new L.Popup()
    koeln.setLatLng([50.938056,6.956944])
    koeln.setContent("<a href='/move_to/koeln'>Köln</a>")
    map.addLayer(koeln)

    berlin = new L.Popup()
    berlin.setLatLng([52.516667,13.383333])
    berlin.setContent("<a href='/move_to/berlin'>Berlin</a>")
    map.addLayer(berlin)
