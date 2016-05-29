namespace :uberspace do
  HTACCESS_TEMPLATE=<<EOF
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule (.*) http://localhost:<%= ENV["UNICORN_PORT"] %>/$1 [P]
Options +SymLinksIfOwnerMatch
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/javascript text/javascript
EOF
  task :print_htaccess do
    ($stderr.puts "Environment variable UNICORN_PORT is missing"; exit 1) if ENV["UNICORN_PORT"].nil?
    puts ERB.new(HTACCESS_TEMPLATE).result
  end
end
