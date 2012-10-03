$ ->
  suggestion_area = $ "#suggestion_more_as_text_input"
  hints = $ "p", suggestion_area
  labels = hints.text().split ", "
  output = $ "textarea", suggestion_area

  [hints, output].forEach (selector) ->
    selector.hide()

  list = $ "<ul></ul>"
  add_button = ($ "<input></input>").attr
    type: "button"
    value: "Add Row"

  suggestion_area.append list, add_button

  create_select_menu_for = (row) ->
    select_menu = $ "<select></select>"
    labels.forEach (label) ->
      select_menu.append ($ "<option></option>").attr
        label: label
        value: label.toLowerCase()

    select_menu.change push_to_textarea
    row.append select_menu

  create_text_input_for = (row) ->
    text_input = ($ "<input></input>").attr
      type: "text"

    text_input.keyup push_to_textarea
    row.append text_input

  add_row = ->
    row = list.append ($ "<li></li>")
    create_select_menu_for row
    create_text_input_for row

  push_to_textarea = ->
    output = $ "textarea", suggestion_area
    output.val ""
    ($ "li", list).each (_, row) ->
      key = ($ "select", row).val()
      value = ($ "input", row).val()
      output.val output.val() + key + ": " + value + "\n"

  add_button.click add_row
  add_button.click()
