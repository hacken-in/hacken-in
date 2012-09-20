ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # Here is an example of a simple dashboard with columns and panels.
    columns do
      column do
        panel I18n.t("active_admin.statistics.tag_distribution") do
          stats = Tagging.distribution

          div "class" => "pie-chart",
            "data-numbers" => stats.map { |stat| stat[1] }.join(","),
            "data-labels"  => stats.map { |stat| stat[0] }.join(","),
            "data-size"    => "400"
          end
        end

      column do
        panel I18n.t("active_admin.statistics.registered_users") do
          stats = User.over_time

          div "class" => "line-chart",
            "data-x" => stats.map { |stat| stat[0] }.join(","),
            "data-y" => stats.map { |stat| stat[1] }.join(","),
            "data-size" => "266"
        end
      end
    end
  end
end
