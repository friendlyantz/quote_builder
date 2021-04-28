# frozen_string_literal: true

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

Rails.logger.info 'APPCLEANED' # used by log_fail.rb
