# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{analytics-logger}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jared McFarland of FutureAdvisor"]
  s.cert_chain = ["/Users/jared/gems/keys/gem-public_cert.pem"]
  s.date = %q{2011-04-18}
  s.description = %q{Monitors, logs and tracks events}
  s.email = %q{jared@futureadvisor.com}
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "lib/analytics_logger.rb", "lib/analytics_logger/analytics.rb", "lib/analytics_logger/analytics/formatters.rb", "lib/analytics_logger/analytics/loggers.rb", "lib/analytics_logger/analytics/maintenance.rb", "lib/analytics_logger/analytics/selectors.rb", "lib/generators/analytics/USAGE", "lib/generators/analytics/analytics_generator.rb", "lib/generators/analytics/templates/analytics_event.rb", "lib/generators/analytics/templates/analytics_event_type.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.rdoc", "Rakefile", "analytics-logger.gemspec", "generators/analytics/USAGE", "generators/analytics/analytics_generator.rb", "generators/analytics/templates/analytics_event.rb", "generators/analytics/templates/analytics_event_type.rb", "lib/analytics_logger.rb", "lib/analytics_logger/analytics.rb", "lib/analytics_logger/analytics/formatters.rb", "lib/analytics_logger/analytics/loggers.rb", "lib/analytics_logger/analytics/maintenance.rb", "lib/analytics_logger/analytics/selectors.rb", "lib/generators/analytics/USAGE", "lib/generators/analytics/analytics_generator.rb", "lib/generators/analytics/templates/analytics_event.rb", "lib/generators/analytics/templates/analytics_event_type.rb"]
  s.homepage = %q{https://github.com/FutureAdvisor/analytics-logger}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Analytics-logger", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{analytics-logger}
  s.rubygems_version = %q{1.6.0}
  s.signing_key = %q{/Users/jared/gems/keys/gem-private_key.pem}
  s.summary = %q{Monitors, logs and tracks events}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
