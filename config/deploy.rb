set :application, 'lh2bc'
set :repository, 'git@github.com:fs/ruby-lh2bc.git'

server 'flatsoft-rails.flatsoft.ru', :app

set :user, 'admin'
set :deploy_to, "/var/www/rails/#{application}"
set :use_sudo, false
set :branch, 'master'
set :scm, :git
set :deploy_via, :remote_cache

after 'deploy:symlink', 'deploy:update_crontab'

namespace :deploy do
  [:finalize_update, :migrate, :start, :stop, :restart].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Run this x every successful deployment"
  task :after_default do
    cleanup
  end

  desc "Update the crontab file"
  task :update_crontab do
    run "cd #{current_path} && whenever -f config/cron.rb --update-crontab #{application}"
  end
end
