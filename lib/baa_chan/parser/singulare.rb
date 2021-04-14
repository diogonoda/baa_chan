# frozen_string_literal: true

require 'baa_chan/trade_confirmation'
require 'baa_chan/trade'
require 'baa_chan/costs'
require 'date'

module BaaChan
  module Parser
    class Singulare
      def initialize(lines)
        @lines = lines
      end

      def parse
        TradeConfirmation.new(broker, trade_confirmation_number, trade_date, trades, costs)
      end

      private

      def broker
        broker ||= @lines[4]
      end

      def trade_confirmation_number
        trade_confirmation_number ||= @lines[3].split[0]
      end

      def trade_date
        trade_date ||= Date.parse @lines[3].split[2]
      end

      def trades
        trades ||= [TradeParser.new(@lines[25]).parse]
      end

      def costs
        costs ||= CostsParser.new(@lines).parse
      end
    end

    class TradeParser
      def initialize(line)
        @line = line
      end

      def parse
        Trade.new(operation, ticker, quantity, price)
      end

      private

      def operation
        operation ||= @line.split[2] == 'V' ? 'Sell' : 'Buy'
      end

      def ticker
        ticker ||= @line.split[6]
      end

      def quantity
        quantity ||= @line.split[9].to_i
      end

      def price
        price ||= @line.split[10].gsub(',', '.').to_f
      end
    end

    class CostsParser
      def initialize(lines)
        @lines = lines
      end

      def parse
        Costs.new(clearing_fee, registration_fee, emoluments, brokerage, iss, irrf)
      end

      private

      def clearing_fee
        clearing_fee ||= @lines[80].split[7].gsub(',', '.').to_f
      end

      def registration_fee
        registration_fee ||= @lines[81].split[7].gsub(',', '.').to_f
      end

      def emoluments
        emoluments ||= @lines[87].split[5].gsub(',', '.').to_f
      end

      def brokerage
        brokerage ||= @lines[91].split[1].gsub(',', '.').to_f
      end

      def iss
        iss ||= @lines[92].split[3].gsub(',', '.').to_f
      end

      def irrf
        irrf ||= @lines[93].split[14].gsub(',', '.').to_f
      end
    end
  end
end
