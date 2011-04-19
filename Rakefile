require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('analytics-logger', '0.3.2') do |p|
  p.description               = "Monitors, logs and tracks events"
  p.url                       = "https://github.com/FutureAdvisor/analytics-logger"
  p.author                    = "Jared McFarland of FutureAdvisor"
  p.email                     = "jared@futureadvisor.com"
  p.ignore_pattern            = ["tmp/*", "script/*"]
  p.development_dependencies  = ["activesupport"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }