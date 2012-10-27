$ ->
  selectors = ($ "#SingleEvent, #BlogPost, #Event")
  type = ($ "#box_content_type")
  selects = {}
  target = selectors.parent()

  selectors.each (_, select) ->
    select = $(select).detach()
    selects[select.attr "id"] = select

  type.change (e) ->
    selectors.each -> ($ this).detach()
    selects[e.target.value].appendTo ($ target)

  type.change()
