server 'dubhe.uberspace.de',
       roles: %{app web},
       user: 'hacken'

set :deploy_to, '~/hacken-in-master'
set :branch, 'back-to-uberspace'
