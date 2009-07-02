set :cron_log, "/tmp/lh2bc.log"

every :hourly do
  command '/home/timurv/develop/prj/flatsoft/lh2bc/bin/lh2bc'
end
