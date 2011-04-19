include 'analytics/formatters'
include 'analytics/loggers'
include 'analytics/maintenance'
include 'analytics/selectors'

#
# This is the parent class for AnalyticsEvent and AnalyticsEventTypes
# You shouldn't access either child class directly, it should all be coordinated through Analytics
#
module Analytics

  class << self
    include Analytics::Loggers
    include Analytics::Selectors
    include Analytics::Formatters
    include Analytics::Maintenance
  end

end
