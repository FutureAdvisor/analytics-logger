class AnalyticsGenerator < Rails::Generators::Base
  def manifest
    record do |m|
      m.file 'analytics_event.rb', 'app/models/analytics_event.rb'
      m.file 'analytics_event_type.rb', 'app/models/analytics_event_type.rb'
    end
  end
end