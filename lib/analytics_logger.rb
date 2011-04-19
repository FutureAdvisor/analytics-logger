require 'active_record'

begin
  AnalyticsEvent
  AnalyticsEventType
rescue
  p "WARNING: You appear to be missing the Analytics models.  Make sure you run the analytics generator."
end

require 'analytics_logger/analytics' unless defined?(AnalyticsEvent).nil? or defined?(AnalyticsEventType).nil?