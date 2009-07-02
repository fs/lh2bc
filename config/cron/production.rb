set :cron_log, "/var/www/rails/lh2bc/production/current/log/lh2bc.log"

every :hourly do
  command '/var/www/rails/lh2bc/production/current/bin/lh2bc'
end
