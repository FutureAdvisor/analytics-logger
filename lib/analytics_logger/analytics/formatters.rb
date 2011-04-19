# 
# The formatters for the Analytics class (may eventually split this out to Analytics::Formatters and Analytics::Formatters::HighCharts)
# 

module Analytics::Formatters

  def date_array_for_highcharts(events)
    events.map {|ae| "'#{ae.created_at.strftime("%m/%d/%y")}'" }.uniq.sort
  end
  
  def month_array_for_highcharts(events)
    events.map {|ae| "'#{ae.created_at.strftime("%b %Y")}'" }.uniq
  end
  
  def total_data_array_for_highcharts(events)
    dates = events.map {|ae| "'#{ae.created_at.strftime("%m/%d/%y")}'" }.sort
    keys = dates.uniq
    keys.map {|key| dates.count(key) }
  end
  
  def total_month_data_array_for_highcharts(events)
    dates = events.map {|ae| "'#{ae.created_at.strftime("%b %Y")}'" }
    keys = dates.uniq
    keys.map {|key| dates.count(key) }
  end
  
end