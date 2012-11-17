$ ->
  calendar_modal = ($ '#calendarExportModal')

  if calendar_modal.size() > 0
    radio_buttons = calendar_modal.find('.calendar-import-setting')

    radio_buttons.click ->
      webcal_import_url = ($ this).data('webcal-url')
      http_import_url = ($ this).data('http-url')
      ($ '.calendar-import-url').val(http_import_url)
      ($ '.calendar-import-button').attr('href', webcal_import_url)
      ($ '.calendar-import-button-google').attr('href', "http://google.com/calendar/render?cid=#{escape(http_import_url)}")

    if radio_buttons.size() > 0
      radio_buttons[0].click()
