# frozen_string_literal: true

class Layout
  LAYOUTS_PATH = 'lib/baa_chan/layouts'

  def initialize(broker)
    @broker = broker
  end

  def attributes
    @attributes ||= YAML.safe_load(
      File.read(File.join(LAYOUTS_PATH, "#{@broker}.yml")), aliases: true
    )
  end

  def line
    attributes[caller_locations.first.label]['line'].to_i
  end

  def index(attr_name = caller_locations.first.label)
    attributes[attr_name]['index'].to_i
  end

  def regexp_for(attr)
    attributes[attr]['regexp']
  end

  def trade
    @trade ||= attributes['trades']
  end

  def trade_prefix
    trade['prefix']
  end

  def trade_index(asset)
    trade[asset][caller_locations.first.label]['index'].to_i
  end

  def trade_regexp(asset)
    trade[asset][caller_locations.first.label]['regexp']
  end
end
