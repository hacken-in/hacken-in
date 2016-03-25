server 'dubhe.uberspace.de',
       roles: %{app web},
       user: 'hacken'

set :deploy_to, '~/hacken-in-production'
set :branch, 'back-to-uberspace'
