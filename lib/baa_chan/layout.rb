# frozen_string_literal: true

class Layout
  LAYOUTS_PATH = 'lib/baa_chan/layouts'

  def initialize(broker)
    @broker = broker
  end

  def attributes
    @attributes ||= YAML.safe_load(File.read(File.join(LAYOUTS_PATH, "#{@broker}.yml")))
  end

  def line
    attributes[caller_locations.first.label]['line'].to_i
  end

  def index
    attributes[caller_locations.first.label]['index'].to_i
  end
end
