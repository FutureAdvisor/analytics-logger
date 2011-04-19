#
# This is the parent class for AnalyticsEvent and AnalyticsEventTypes
# You shouldn't access either child class directly, it should all be coordinated through Analytics
#
module Analytics
  require 'analytics_logger/analytics/formatters'
  require 'analytics_logger/analytics/loggers'
  require 'analytics_logger/analytics/maintenance'
  require 'analytics_logger/analytics/selectors'
  
  class << self
    include Analytics::Loggers
    include Analytics::Selectors
    include Analytics::Formatters
    include Analytics::Maintenance
  end

end
