# frozen_string_literal: true

# Shared configuration loaded by all entry points (CLI, rake tasks, etc.)

require "bundler/setup"

require "date"
require "thor"
require "hebrew_date"
require "terminal-table"
require "pastel"

# Project modules
module Daniel70Weeks
  ROOT = File.expand_path(__dir__)

  # 360-day prophetic year
  PROPHETIC_YEAR_DAYS = 360

  # 69 weeks = 69 * 7 = 483 prophetic years
  PROPHETIC_WEEKS = 69
  PROPHETIC_YEARS = PROPHETIC_WEEKS * 7  # 483
  TOTAL_DAYS = PROPHETIC_YEARS * PROPHETIC_YEAR_DAYS  # 173,880
end

# Load project modules
require_relative "lib/converter"
require_relative "lib/parser"
