set :cron_log, "/var/www/rails/lh2bc/current/log/lh2bc.log"

every :hourly do
  command '/var/www/rails/lh2bc/current/bin/lh2bc -c /var/www/rails/lh2bc/shared/config.yml'
end
