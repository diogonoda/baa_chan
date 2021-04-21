# frozen_string_literal: true

module BaaChan
  class MalformedPDFError < StandardError; end

  class UnknownLayoutError < StandardError; end

  class Reader
    BROKER_LIST = {
      singulare: 'Singulare - corretora de titulos de valores mobiliarios',
      genial: 'GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIÁRIOS S.A.'
    }.freeze

    def initialize(source)
      @source = source
    end

    def call
      parse(PdfToText.call(@source))
    end

    private

    def parse(text)
      lines = sanitize(text)

      layout = if lines[3] == BROKER_LIST[:singulare]
                 Layout.new('singulare')
               elsif lines[4] == BROKER_LIST[:genial]
                 Layout.new('genial')
               end

      raise UnknownLayoutError if layout.nil?

      Parser.new(lines, layout).call
    end

    def sanitize(content)
      content.split("\n").map(&:strip)
    end
  end
end

require 'baa_chan/pdf_to_text'
require 'baa_chan/parser'
require 'baa_chan/layout'
