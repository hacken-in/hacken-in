ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    panel I18n.t("active_admin.dashboard") do
      I18n.t("active_admin.welcome_text")
    end
  end
end
