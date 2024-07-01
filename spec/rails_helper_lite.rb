require 'simplecov'

SimpleCov.start do
  minimum_coverage ENV.fetch('MIN_COVERAGE', 0).to_i
end

require 'rails/all'

Rails.logger = Logger.new(STDOUT)