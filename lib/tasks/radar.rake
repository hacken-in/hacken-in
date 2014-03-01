namespace :radar do

  desc "check each radar item"
  task fetch: :environment do
    RadarSetting.all.each do |setting|
      setting.fetch
    end
  end

end
