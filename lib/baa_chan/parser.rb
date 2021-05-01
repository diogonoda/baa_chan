# frozen_string_literal: true

require 'baa_chan/trade_confirmation'
require 'baa_chan/trade'
require 'baa_chan/costs'
require 'date'
require 'yaml'

module BaaChan
  class CostsParserError < StandardError; end

  class Parser
    def initialize(lines, layout)
      @lines = lines
      @layout = layout
    end

    def call
      TradeConfirmation.new(broker, trade_confirmation_number, trade_date, trades, costs)
    end

    private

    def broker
      @broker ||= @lines[@layout.line]
    end

    def trade_confirmation_number
      @trade_confirmation_number ||= @lines[@layout.line].split[@layout.index]
    end

    def trade_date
      @trade_date ||= Date.parse @lines[@layout.line].split[@layout.index]
    end

    def trades
      @trades ||= TradeParser.new(@lines, @layout).parse
    end

    def costs
      @costs ||= CostsParser.new(@lines, @layout).parse
    end
  end

  class TradeParser
    def initialize(lines, layout)
      @lines = lines
      @layout = layout
    end

    def parse
      @lines.each_with_object([]) do |line, trades|
        next unless line.include? @layout.trade_prefix

        @asset = line.include?('OPCAO') ? 'option' : 'stock'

        @trade_line = line
        trades << Trade.new(operation, ticker, quantity, price)
      end
    end

    private

    def operation
      @trade_line.split[@layout.trade_index(@asset)] == 'V' ? 'Sell' : 'Buy'
    end

    def ticker
      @trade_line.split(/\s{2,}/)[@layout.trade_index(@asset)]
    end

    def quantity
      @trade_line.scan(Regexp.new(@layout.trade_regexp(@asset)))[0].strip.gsub('.', '').to_i
    end

    def price
      @trade_line.scan(Regexp.new(@layout.trade_regexp(@asset)))[0].gsub(',', '.').to_f
    end
  end

  class CostsParser
    def initialize(lines, layout)
      @lines = lines
      @layout = layout
    end

    def parse
      Costs.new(brokerage, clearing_fee, registration_fee, emoluments, { iss: iss, irrf: irrf, pis_cofins: pis_cofins })
    rescue StandardError => e
      raise CostsParserError, e.message
    end

    private

    def value_for(attr_name)
      @lines.find { |line| line.match? @layout.regexp_for(attr_name) }
            .split[@layout.index(attr_name)]
            .gsub(',', '.')
            .to_f
    end

    def brokerage
      value_for('brokerage')
    rescue NoMethodError
      0.0
    end

    def clearing_fee
      value_for('clearing_fee')
    end

    def registration_fee
      value_for('registration_fee')
    end

    def emoluments
      value_for('emoluments')
    end

    def iss
      value_for('iss')
    rescue NoMethodError
      0.0
    end

    def irrf
      value_for('irrf')
    rescue NoMethodError
      0.0
    end

    def pis_cofins
      value_for('pis_cofins')
    rescue NoMethodError
      0.0
    end
  end
end
