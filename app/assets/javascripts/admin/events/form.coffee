$ ->
  if $(".admin_events.edit,.admin_events.new").length > 0
    console.log "penis"
    @rules = []
    @exdates = []

    dayRules = {
      1: "ersten",
      2: "zweiten",
      3: "dritten",
      4: "vierten",
      5: "fünften",
      "-1": "letzten"
    }

    weekdays = {
      "monday": "Montag",
      "tuesday": "Dienstag",
      "wednesday": "Mittwoch",
      "thursday": "Donnerstag",
      "friday": "Freitag",
      "saturday": "Samstag",
      "sunday": "Sonntag"
    }

    repaint = =>
      $("ul.rules").empty()
      for rule, i in @rules
        rHtml = "<li>Jeden #{dayRules[rule.interval]} #{weekdays[rule.days[0]]} <a href='#' class='delete-rule icon-trash' data-no='#{i}'></a></li>"
        $("ul.rules").append(rHtml)

      $("ul.excludes").empty()
      for date, i in @exdates
        display = moment(date).format("DD.MM.YYYY, H:mm:ss")
        $("ul.excludes").append("<li>#{display} <a href='#' class='delete-exclude icon-trash' data-no='#{i}'></a></li>")

    init = =>
      @rules = JSON.parse($("#event_schedule_rules_json").val())
      for date in JSON.parse($("#event_excluded_times_json").val())
        @exdates.push new Date(Date.parse(date))

    reserialize = =>
      $("#event_schedule_rules_json").val(JSON.stringify(@rules))
      $("#event_excluded_times_json").val(JSON.stringify(@exdates))

    init()
    repaint()

    self = this

    $(".delete-rule").on 'click', ->
      if (confirm("Wirklich löschen?"))
        self.rules.splice $(this).attr("data-no"), 1
      repaint()
      reserialize()
      false

    $(".delete-exclude").on 'click', ->
      if (confirm("Wirklich löschen?"))
        self.exdates.splice $(this).attr("data-no"), 1
      repaint()
      reserialize()
      false

    $("#add_rule").click =>
      @rules.push {
        interval: $("#week_number").val(),
        days: [
          $("#day_of_week").val()
        ],
        type: "monthly"
      }
      repaint()
      reserialize()
      false
