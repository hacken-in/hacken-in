namespace :uberspace do
  HTACCESS_TEMPLATE=<<EOF
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule (.*) http://localhost:<%= ENV["PUMA_PORT"] %>/$1 [P]
Options +SymLinksIfOwnerMatch
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/javascript text/javascript
EOF
  task :print_htaccess do
    ($stderr.puts "Environment variable PUMA_PORT is missing"; exit 1) if ENV["PUMA_PORT"].nil?
    puts ERB.new(HTACCESS_TEMPLATE).result
  end
  task :letsencrypt_renew do
    system "letsencrypt certonly"
  end
end
