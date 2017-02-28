namespace :release do
  GIT_LOG_FORMAT='* %h %s'

  desc "Show changes since latest tag. Please be sure to fetch all tags."
  task :changelog do
    `git fetch --tags https://github.com/hacken-in/hacken-in.git`
    latest_tag = `git describe --tags --abbrev=0`.strip
    puts "# Changes since tag #{latest_tag}"
    system "git log --pretty='#{GIT_LOG_FORMAT}' #{latest_tag}..HEAD"
  end
end
