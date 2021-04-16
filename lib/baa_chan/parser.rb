# frozen_string_literal: true

require 'baa_chan/trade_confirmation'
require 'baa_chan/trade'
require 'baa_chan/costs'
require 'date'
require 'yaml'

module BaaChan
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

        @trade_line = line
        trades << Trade.new(operation, ticker, quantity, price)
      end
    end

    private

    def operation
      @trade_line.split[@layout.index] == 'V' ? 'Sell' : 'Buy'
    end

    def ticker
      @trade_line.split[@layout.index]
    end

    def quantity
      @trade_line.split[@layout.index].to_i
    end

    def price
      @trade_line.split[@layout.index].gsub(',', '.').to_f
    end
  end

  class CostsParser
    def initialize(lines, layout)
      @lines = lines
      @layout = layout
    end

    def parse
      Costs.new(brokerage, clearing_fee, registration_fee, emoluments, { iss: iss, irrf: irrf, pis_cofins: pis_cofins })
    end

    private

    def brokerage
      @brokerage ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    end

    def clearing_fee
      @clearing_fee ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    end

    def registration_fee
      @registration_fee ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    end

    def emoluments
      @emoluments ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    end

    def iss
      @iss ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    end

    def irrf
      @irrf ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    rescue NoMethodError
      0.0
    end

    def pis_cofins
      @pis_cofins ||= @lines[@layout.line].split[@layout.index].gsub(',', '.').to_f
    rescue NoMethodError
      0.0
    end
  end
end
