# frozen_string_literal: true

module BaaChan
  class Costs
    attr_accessor :clearing_fee, :registration_fee, :emoluments, :brokerage, :iss, :irrf

    def initialize(clearing_fee, registration_fee, emoluments, brokerage, iss, irrf)
      @clearing_fee = clearing_fee
      @registration_fee = registration_fee
      @emoluments = emoluments
      @brokerage = brokerage
      @iss = iss
      @irrf = irrf
    end
  end
end
