require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('event-logger', '0.1.0') do |p|
  p.description               = "Monitors, logs and tracks events"
  p.url                       = "https://github.com/FutureAdvisor/analytics-logger"
  p.author                    = "Jared McFarland"
  p.email                     = "jared@futureadvisor.com"
  p.ignore_pattern            = ["tmp/*", "script/*"]
  p.development_dependencies  = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }