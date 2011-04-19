class AnalyticsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  def build
    copy_file 'analytics_event.rb', 'app/models/analytics_event.rb'
    copy_file 'analytics_event_type.rb', 'app/models/analytics_event_type.rb'
  end
end