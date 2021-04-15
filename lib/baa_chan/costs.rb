# frozen_string_literal: true

module BaaChan
  class Costs
    attr_accessor :clearing_fee, :registration_fee, :emoluments,
                  :brokerage, :iss, :irrf, :pis_cofins

    def initialize(brokerage, clearing_fee, registration_fee, emoluments, options)
      @brokerage = brokerage
      @clearing_fee = clearing_fee
      @registration_fee = registration_fee
      @emoluments = emoluments
      @iss = options[:iss] || 0.0
      @irrf = options[:irrf] || 0.0
      @pis_cofins = options[:pis_cofins] || 0.0
    end
  end
end
