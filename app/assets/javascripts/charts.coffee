# = require raphael.js
# = require g.raphael.js
# = require g.pie.js
# = require g.line.js

draw = ->
  $(".pie-chart").each ->
    target    = $ @
    numbers   = target.data("numbers").split(",").map (num) -> parseInt num
    legend    = target.data("labels").split(",").map (label) -> "%%.%% #{label}"
    width     = parseInt target.data("size")
    height    = (2/3) * width
    radius    = width / 3.5
    top       = radius * 1.1
    left      = radius * 1.1
    speed     = 500
    animation = "bounce"

    animate_sector = (sector, scale, cx, cy) ->
      sector.animate
        transform: "s#{scale} #{scale} #{cx} #{cy}"
      , speed, animation

    animate_label = (label, radius, weight) ->
      label[0].animate r: radius, speed, animation
      label[1].attr "font-weight": weight

    Raphael(
      target[0]
      width
      height
    ).piechart(
      left
      top
      radius
      numbers
      legend: legend
    ).hover ->
      animate_sector @sector, 1.1, @cx, @cy
      animate_label @label, 6.5, "bold"
    , ->
      animate_sector @sector, 1, @cx, @cy
      animate_label @label, 5, "normal"

  $(".line-chart").each ->
    target = $ @
    x = target.data("x").split(",").map (num) -> (new Date num).getTime()
    y = target.data("y").split(",").map (num) -> parseInt num
    width = parseInt target.data("size")

    r = Raphael(
      target[0]
      width * 1.5
      width
    ).linechart(
      20
      0
      300
      220
      x
      y
      shade: true
      axis: "0 0 0 1"
      symbol: "circle"
    )

$ -> draw()
