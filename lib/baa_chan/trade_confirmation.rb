# frozen_string_literal: true

require 'jbuilder'

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

    def to_builder
      Jbuilder.encode do |json|
        json.call(
          self,
          :broker,
          :trade_confirmation_number,
          :trade_date
        )

        json.trades @trades do |trade|
          json.operation trade.operation
          json.ticker trade.ticker
          json.quantity trade.quantity
          json.price trade.price
        end

        json.costs do
          json.brokerage @costs.brokerage
          json.clearing_fee @costs.clearing_fee
          json.registration_fee @costs.registration_fee
          json.emoluments @costs.emoluments
          json.iss @costs.iss if @costs.iss
          json.irrf @costs.irrf if @costs.irrf
          json.pis_cofins @costs.pis_cofins if @costs.pis_cofins
        end
      end
    end
  end
end
