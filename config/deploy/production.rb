server 'flatsoft-rails.flatsoft.ru', :app

set :user, 'admin'
set :deploy_to, "/var/www/apps/#{application}"
set :use_sudo, false
set :branch, 'master'
