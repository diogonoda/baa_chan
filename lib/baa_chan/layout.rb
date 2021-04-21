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

  def trade_prefix
    attributes['trades']['prefix']
  end

  def brokerage_regexp
    attributes['brokerage']['regexp']
  end

  def clearing_fee_regexp
    attributes['clearing_fee']['regexp']
  end

  def emoluments_regexp
    attributes['emoluments']['regexp']
  end

  def registration_fee_regexp
    attributes['registration_fee']['regexp']
  end

  def iss_regexp
    attributes['iss']['regexp']
  end

  def irrf_regexp
    attributes['irrf']['regexp']
  end

  def pis_cofins_regexp
    attributes['pis_cofins']['regexp']
  end
end
