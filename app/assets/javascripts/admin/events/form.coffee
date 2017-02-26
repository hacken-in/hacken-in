$ ->
  if $(".admin_events.edit,.admin_events.new").length > 0
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

    weekRules = {
      1: "Jede",
      2: "Jede 2.",
      3: "Jede 3.",
      4: "Jede 4.",
      5: "Jede 5."
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
        rHtml = "<li>"
        if (rule.type == "monthly")
          rHtml += "Jeden #{dayRules[rule.interval]} #{weekdays[rule.days[0]]}"
        else if (rule.type == "weekly")
          rHtml += "#{weekRules[rule.interval]} Woche an einem #{weekdays[rule.days[0]]}"
        rHtml += " <a href='#' class='delete-rule' data-no='#{i}'><i class='fa fa-trash-o'></i></a></li>"
        $("ul.rules").append(rHtml)

      $("ul.excludes").empty()
      for date, i in @exdates
        display = moment(date).format("DD.MM.YYYY, H:mm:ss")
        $("ul.excludes").append("<li>#{display} <a href='#' class='delete-exclude' data-no='#{i}'><i class='fa fa-trash-o'></i></a></li>")

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

    $(document).on 'click', ".delete-rule", ->
      if (confirm("Wirklich löschen? Alle zukünftigen Termine, die auf dieser Regel basieren, werden dabei gelöscht."))
        self.rules.splice $(this).attr("data-no"), 1
      repaint()
      reserialize()
      false

    $(document).on 'click', ".delete-exclude", ->
      if (confirm("Wirklich löschen? Wenn dieser Termin in der Zukunft liegt wird er wieder angelegt sollte eine Regel diesen anlegen wollen."))
        self.exdates.splice $(this).attr("data-no"), 1
      repaint()
      reserialize()
      false

    $("#add_rule_monthly").click =>
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

    $("#add_rule_weekly").click =>
      @rules.push {
        interval: $("#week_recurrence").val(),
        days: [
          $("#repeat_week_day").val()
        ],
        type: "weekly"
      }
      repaint()
      reserialize()
      false
