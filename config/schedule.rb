# set :output, "/path/to/my/cron_log.log"

every 1.day do
  runner 'User.send_daily_digest'
end

every 1.hour do
  rake 'ts:index'
end
