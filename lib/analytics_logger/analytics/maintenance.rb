#
# The maintenance methods associated with the analytics
#

module Analytics::Maintenance
  class << Analytics::Maintenance
  private
    def option_value_must_be_a(obj_type)
      lambda { |option_value| option_value.is_a?(obj_type) }
    end
  end

  CLEAR_EVENTS_OBJECT_OPTIONS = {
    :all    => option_value_must_be_a(TrueClass),
    :audit  => option_value_must_be_a(TrueClass),
    :no_log => option_value_must_be_a(TrueClass),
    :since  => option_value_must_be_a(Time),
    :before => option_value_must_be_a(Time)
  }
  CLEAR_EVENTS_OBJECT_OR_ARRAY_OPTIONS = {
    :level    => lambda { |option_value| AnalyticsEventType::LEVELS.include?(option_value) },
    :type     => option_value_must_be_a(AnalyticsEventType),
    :user_id  => option_value_must_be_a(Fixnum)
  }
  VALID_CLEAR_EVENTS_OPTIONS = CLEAR_EVENTS_OBJECT_OPTIONS.keys + CLEAR_EVENTS_OBJECT_OR_ARRAY_OPTIONS.keys

  CLEAR_EVENTS_HELP = <<-CLEAR_EVENTS_HELP_TEXT
At least one of the following options must be specified:
  :all      => true
    Clear all analytics events; if specified, must be the only option.

  :audit    => true
    Clear audit level analytics events, which by default are not cleared.

  :no_log   => true
    Do not log an analytics event indicating that the log was cleared.

  :since    => <time>
    Clear only analytics events occurring since the specified time.

  :before   => <time>
    Clear only analytics events occurring before the specified time.

  :level    => <level or array of levels>
    Clear only analytics events belonging to the specified level(s).

  :type     => <event type or array of event types>
    Clear only analytics events belonging to the specified type(s).

  :user_id  => <user id or array of user ids>
    Clear only analytics events associated with the specified user(s).

  CLEAR_EVENTS_HELP_TEXT

  def clean_up_events
    AnalyticsEventType.all.each do |event_type|
      # Make sure the counter cache is correct in case it became out-of-sync.
      AnalyticsEventType.reset_counters(event_type.id, :analytics_events)

      # The event type is no longer needed if there are no associated events.
      if event_type.analytics_events_count == 0
        event_type.destroy
      end
    end
    true
  end

  def clear_events(options = {})
    begin
      validate_clear_events_options(options)

      events_to_clear = AnalyticsEvent
      events_to_clear = events_to_clear.is_not_audit_level            unless options[:audit]
      events_to_clear = events_to_clear.since_time(options[:since])   if options[:since]
      events_to_clear = events_to_clear.before_time(options[:before]) if options[:before]
      events_to_clear = events_to_clear.in_level(options[:level])     if options[:level]
      events_to_clear = events_to_clear.in_type(options[:type])       if options[:type]
      events_to_clear = events_to_clear.for_users(options[:user_id])  if options[:user_id]
      events_to_clear = events_to_clear.all

      puts "Clearing #{events_to_clear.count} events..."
      events_to_clear.each(&:destroy)

      if !options[:audit] && AnalyticsEvent.in_level(AnalyticsEventType::AUDIT).count > 0
        puts
        puts 'Note: Audit level events are not cleared unless :audit => true is specified.'
      end

      Analytics.audit('Analytics: Cleared analytics events', :count => events_to_clear.count, :options => options) unless options[:no_log] || events_to_clear.count == 0

      # Clean up the state of analytics objects after clearing.
      clean_up_events
    rescue ArgumentError => error
      puts "#{error.class.name}: #{error.message}"
      puts
      puts CLEAR_EVENTS_HELP
      false
    end
  end

private

  def validate_clear_events_options(options)
    raise ArgumentError.new("invalid options specified: #{options.inspect}") unless options.is_a?(Hash)
    raise ArgumentError.new("no options specified") if options.empty?

    invalid_options = options.keys - VALID_CLEAR_EVENTS_OPTIONS
    raise ArgumentError.new("invalid options specified: #{invalid_options.inspect}") unless invalid_options.empty?

    if options[:all]
      raise ArgumentError.new("if :all is specified, it must be the only option specified") if options.count > 1
    end

    CLEAR_EVENTS_OBJECT_OPTIONS.each do |option, validate_value|
      option_value = options[option]
      if option_value
        raise ArgumentError.new("invalid value for #{option.inspect} option: #{option_value.inspect}") unless validate_value.call(option_value)
      end
    end

    CLEAR_EVENTS_OBJECT_OR_ARRAY_OPTIONS.each do |option, validate_value|
      option_value = options[option]
      if option_value
        validate_array = lambda { option_value.is_a?(Array) && option_value.all? { |value| validate_value.call(value) } }
        raise ArgumentError.new("invalid value for #{option.inspect} option: #{option_value.inspect}") unless validate_value.call(option_value) || validate_array.call
      end
    end

    true
  end
end
