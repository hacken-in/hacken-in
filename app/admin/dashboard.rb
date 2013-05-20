ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # Here is an example of a simple dashboard with columns and panels.
    columns do
      column do
        panel I18n.t("active_admin.statistics.events_by_category") do
          pie_chart Event.group_by_category
        end
      end

      column do
        panel I18n.t("active_admin.statistics.users_over_time") do
          line_chart User.over_time
        end
      end
    end

    columns do
      column do
        panel I18n.t("active_admin.statistics.single_events_this_week_by_day") do
          column_chart SingleEvent.this_week_by_day
        end
      end

      column do
        panel I18n.t("active_admin.statistics.single_events_this_week_by_category") do
          pie_chart SingleEvent.this_week_by_category
        end
      end
    end
  end
end
