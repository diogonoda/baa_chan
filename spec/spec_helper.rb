# frozen_string_literal: true

require 'baa_chan/reader'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Helpers
end
