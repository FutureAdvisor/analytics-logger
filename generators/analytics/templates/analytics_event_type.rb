#
# This is the parent category for a particular event
#
class AnalyticsEventType < ActiveRecord::Base

  LEVELS = ["Error", "Warning", "Audit", "Info"]

  # Define constants for each level.
  LEVELS.each do |level|
    class_eval "#{level.upcase} = #{level.inspect}"
  end

  has_many :analytics_events, :dependent => :destroy

  validates_presence_of   :name

  named_scope :sort_by_count, :order => "analytics_events_count DESC"

end
