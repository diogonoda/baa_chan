# frozen_string_literal: true

module BaaChan
  class Trade
    attr_accessor :operation, :ticker, :quantity, :price

    def initialize(operation, ticker, quantity, price)
      @operation = operation
      @ticker = ticker
      @quantity = quantity
      @price = price
    end
  end
end
