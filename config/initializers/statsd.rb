# frozen_string_literal: true

StatsD.prefix = 'homebot.ottawa'

StatsD.backend = StatsD::Instrument::Backends::UDPBackend.new("127.0.0.1:8125", :datadog)

# Sets up a logger backend
# StatsD.backend = StatsD::Instrument::Backends::LoggerBackend.new(Rails.logger)
