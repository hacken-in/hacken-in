//= require jquery
//= require jquery_ujs
//= require chosen-jquery

$(function() {
  $(".chosen-select").chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched'
  });

  // TODO: The following code was compiled from an old CoffeeScript file
  // It needs to be rewritten. This is madness.
  var dayRules, init, repaint, reserialize, self, weekRules, weekdays;
  if ($(".admin_events.edit,.admin_events.new").length > 0) {
    this.rules = [];
    this.exdates = [];
    dayRules = {
      1: "ersten",
      2: "zweiten",
      3: "dritten",
      4: "vierten",
      5: "fünften",
      "-1": "letzten"
    };
    weekRules = {
      1: "Jede",
      2: "Jede 2.",
      3: "Jede 3.",
      4: "Jede 4.",
      5: "Jede 5."
    };
    weekdays = {
      "monday": "Montag",
      "tuesday": "Dienstag",
      "wednesday": "Mittwoch",
      "thursday": "Donnerstag",
      "friday": "Freitag",
      "saturday": "Samstag",
      "sunday": "Sonntag"
    };
    repaint = (function(_this) {
      return function() {
        var date, display, i, j, k, len, len1, rHtml, ref, ref1, results, rule;
        $("ul.rules").empty();
        ref = _this.rules;
        for (i = j = 0, len = ref.length; j < len; i = ++j) {
          rule = ref[i];
          rHtml = "<li>";
          if (rule.type === "monthly") {
            rHtml += "Jeden " + dayRules[rule.interval] + " " + weekdays[rule.days[0]];
          } else if (rule.type === "weekly") {
            rHtml += weekRules[rule.interval] + " Woche an einem " + weekdays[rule.days[0]];
          }
          rHtml += " <a href='#' class='delete-rule' data-no='" + i + "'><i class='fa fa-trash-o'></i></a></li>";
          $("ul.rules").append(rHtml);
        }
        $("ul.excludes").empty();
        ref1 = _this.exdates;
        results = [];
        for (i = k = 0, len1 = ref1.length; k < len1; i = ++k) {
          date = ref1[i];
          results.push($("ul.excludes").append("<li>" + date + " <a href='#' class='delete-exclude' data-no='" + i + "'><i class='fa fa-trash-o'></i></a></li>"));
        }
        return results;
      };
    })(this);
    init = (function(_this) {
      return function() {
        var date, j, len, ref, results;
        _this.rules = JSON.parse($("#event_schedule_rules_json").val());
        ref = JSON.parse($("#event_excluded_times_json").val());
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          date = ref[j];
          results.push(_this.exdates.push(new Date(Date.parse(date))));
        }
        return results;
      };
    })(this);
    reserialize = (function(_this) {
      return function() {
        $("#event_schedule_rules_json").val(JSON.stringify(_this.rules));
        return $("#event_excluded_times_json").val(JSON.stringify(_this.exdates));
      };
    })(this);
    init();
    repaint();
    self = this;
    $(document).on('click', ".delete-rule", function() {
      if (confirm("Wirklich löschen? Alle zukünftigen Termine, die auf dieser Regel basieren, werden dabei gelöscht.")) {
        self.rules.splice($(this).attr("data-no"), 1);
      }
      repaint();
      reserialize();
      return false;
    });
    $(document).on('click', ".delete-exclude", function() {
      if (confirm("Wirklich löschen? Wenn dieser Termin in der Zukunft liegt wird er wieder angelegt sollte eine Regel diesen anlegen wollen.")) {
        self.exdates.splice($(this).attr("data-no"), 1);
      }
      repaint();
      reserialize();
      return false;
    });
    $("#add_rule_monthly").click((function(_this) {
      return function() {
        _this.rules.push({
          interval: $("#week_number").val(),
          days: [$("#day_of_week").val()],
          type: "monthly"
        });
        repaint();
        reserialize();
        return false;
      };
    })(this));
    return $("#add_rule_weekly").click((function(_this) {
      return function() {
        _this.rules.push({
          interval: $("#week_recurrence").val(),
          days: [$("#repeat_week_day").val()],
          type: "weekly"
        });
        repaint();
        reserialize();
        return false;
      };
    })(this));
  }
});
