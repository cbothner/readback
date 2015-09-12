require 'resque' # include resque so we can configure it
Resque.redis = "0.0.0.0:6379" # tell Resque where redis lives
# This will make the tabs show up.
 require 'resque-scheduler'
 require 'resque/scheduler/server'
