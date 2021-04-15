# frozen_string_literal: true

module BaaChan
  class TradeConfirmation
    attr_accessor :broker, :trade_confirmation_number, :trade_date, :trades, :costs

    def initialize(broker, trade_confirmation_number, trade_date, trades, costs)
      @broker = broker
      @trade_confirmation_number = trade_confirmation_number
      @trade_date = trade_date
      @trades = trades
      @costs = costs
    end

    def total_cost
      @costs.brokerage +
        @costs.registration_fee +
        @costs.emoluments +
        @costs.pis_cofins +
        @costs.clearing_fee
    end
  end
end
