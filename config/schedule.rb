set :output, 'log/whenever.log'
set :job_template, "bash -l -c 'source ~/hacken-in-#{Rails.env}.secrets; :job'"

every :day, :at => '03:21am' do
  rake 'twitter:follow'
end

every :day, :at => '05:21am' do
  rake 'twitter:update_lists'
end

every :day, :at => '05:41am' do
  rake 'radar:fetch'
end

every :day, :at => '06:41pm' do
  rake 'radar:fetch'
end

every :day, :at => '00:30am' do
  rake 'single_events:generate'
end

every :day, :at => '02:30am' do
  rake "uberspace:letsencrypt"
end
