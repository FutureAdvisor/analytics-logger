require 'active_record'

begin
  AnalyticsEvent
  AnalyticsEventType
rescue
  raise NameError.new("You're missing the Analytics models.  Make sure you run the analytics generator.")
end

require 'analytics_logger/analytics' unless defined?(AnalyticsEvent).nil? or defined?(AnalyticsEventType).nil?