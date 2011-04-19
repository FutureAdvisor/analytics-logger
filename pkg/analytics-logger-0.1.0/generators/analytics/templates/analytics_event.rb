#
# This is the actual even that gets logged. Belongs to an AnalyticsEventType for sorting and categorizing
#
class AnalyticsEvent < ActiveRecord::Base
  belongs_to :analytics_event_type, :counter_cache => true

  before_save :yamlize_objects

  # Objects assigned to these attributes will be stored in YAML format.
  YAMLIZED_ATTRIBUTES = [:user, :params, :exception, :backtrace, :additional_objects]

  named_scope :has_user,            { :conditions => ["analytics_events.user_id IS NOT NULL"] }
  named_scope :does_not_have_user,  { :conditions => {:user_id => nil} }
  named_scope :unique_users,        { :group => [:user_id] }
  named_scope :is_not_audit_level,  { :conditions => ["analytics_event_types.level != ?", AnalyticsEventType::AUDIT], :joins => :analytics_event_type }
  named_scope :for_users,           lambda { |user_id|  { :conditions => { :user_id => user_id } } }
  named_scope :before_time,         lambda { |time|     { :conditions => ["analytics_events.created_at < ?", time.utc] } }
  named_scope :since_time,          lambda { |time|     { :conditions => ["analytics_events.created_at >= ?", time.utc] } }
  named_scope :in_level,            lambda { |levels|   { :conditions => { :analytics_event_types => { :level => levels } }, :joins => :analytics_event_type } }
  named_scope :in_type,             lambda { |types|    { :conditions => { :analytics_event_type_id => types.is_a?(Array) ? types.map(&:id) : types.id } } }
  named_scope :sort_by_most_recent, :order => "analytics_events.id DESC"

  YAMLIZED_ATTRIBUTES.each do |attr|
    define_method(attr) do
      value = super(attr)

      # The value may be holding nil in YAML format; if so, return nil.
      (value == nil.to_yaml) ? nil : value
    end
  end

  def name
    "#{analytics_event_type.name}"
  end

  #
  # Designed to be used like
  # Analytics.find_by_name("User Logged In").unique_by_user
  # => [array of events unique by user]
  def self.unique_by_user
    AnalyticsEvent.has_user.unique_users + AnalyticsEvent.does_not_have_user
  end

private

  # makes the objects being stored YAML objects
  # so that we can reference them later
  #
  def yamlize_objects
    YAMLIZED_ATTRIBUTES.each do |attr|
      __send__("#{attr.to_s}=".to_sym, __send__(attr).to_yaml)
    end
  end
end
