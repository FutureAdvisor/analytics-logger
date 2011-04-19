#
# The logging methods associated with the analytics
#

module Analytics::Loggers

  # options
  #   :level -> The log level of the event; e.g., AnalyticsEventType::INFO, AnalyticsEventType::AUDIT, AnalyticsEventType::WARNING, AnalyticsEventType::ERROR
  #   :user -> The user that was logged in when the event was triggered
  #   :params -> The params when the event was triggered
  #   :exception -> The exception that was encountered when the event was triggered
  # Any has items that are not an explicitly defined option above, will be stuffed into the "additional_objects" column and stored in the DB
  #
  def log(name, options = {})
    analytics_event = AnalyticsEvent.new(setup_log(name, options))
    analytics_event.save
  end


  # alias methods for auto-assigning log levels
  AnalyticsEventType::LEVELS.each do |level|
    define_method(level.downcase.to_sym) do |name, *args|
      if args[0].nil? || !args[0].is_a?(Hash)
        options = Hash.new
      else
        options = args[0]
      end

      options[:level] = level
      self.log(name, options)
    end
  end

  # same as log, but allows a block, and will only log an event if the block raises an exception
  # will re-throw the exception unless :throw => false is specified
  def log_on_error(name, options = {}, &block)
    options[:level] ||= AnalyticsEventType::ERROR # log as an error by default
    begin
      yield
    rescue
      self.log(name, options)
      raise unless options[:throw] == false
    end
  end

private
  #
  # helper method that takes the name and options passed into log and returns a hash suitable
  # for using with Event.create
  #
  def setup_log(name, options)
    options[:level] ||= AnalyticsEventType::INFO

    level = options.delete(:level)
    user = options.delete(:user)
    user_id = user.nil? ? nil : user.id
    params = options.delete(:params)
    exception = options.delete(:exception)
    backtrace = exception.nil? ? nil : exception.backtrace

    additional_objects = options

    event_type = AnalyticsEventType.find_or_create_by_name_and_level(name, level)

    {
      :analytics_event_type_id => event_type.id,
      :user_id => user_id,
      :user => user,
      :params => params,
      :exception => exception,
      :backtrace => backtrace,
      :additional_objects => additional_objects
    }
  end

end
