# frozen_string_literal: true

require 'pdf-reader'

module BaaChan
  class Reader
    BROKER_LIST = {
      singulare: 'Singulare - corretora de titulos de valores mobiliarios',
      genial: 'GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIÁRIOS S.A.'
    }.freeze

    def initialize(source)
      @source = source
    end

    def call
      PDF::Reader.new(@source).pages.map do |page|
        parse(page.text)
      end
    end

    private

    def parse(text)
      lines = sanitize(text)

      layout = if lines[4] == BROKER_LIST[:singulare]
                 Layout.new('singulare')
               elsif lines[5] == BROKER_LIST[:genial]
                 Layout.new('genial')
               end

      Parser.new(lines, layout).call
    end

    def sanitize(content)
      content.split("\n").map(&:strip)
    end
  end
end

require 'baa_chan/parser'
require 'baa_chan/layout'
