# 
# All the custom selectors for the Analytics class
# 

module Analytics::Selectors
  
  # because AnalyticEvents don't store their own name, we have handy helper to find them
  def find_by_name(name)
    AnalyticsEventType.find_by_name(name).analytics_events
  end
  
  def latest(limit = 2)
    AnalyticsEventType.find(:all, :order => "created_at DESC", :limit => limit)
  end
  
  def sort_events_by_count
    AnalyticsEventType.sort_by_count.all
  end
  
  def find_event_type(id)
    AnalyticsEventType.find(id)
  end
  
end