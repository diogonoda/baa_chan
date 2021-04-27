# frozen_string_literal: true

module BaaChan
  class MalformedPDFError < StandardError; end

  class UnknownLayoutError < StandardError; end

  class Reader
    BROKER_LIST = {
      singulare: 'Singulare - corretora de titulos de valores mobiliarios',
      genial: 'GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIÁRIOS S.A.',
      clear: 'CLEAR CORRETORA - GRUPO XP'
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

      layout = Layout.new(detect_layout(lines))

      Parser.new(lines, layout).call
    end

    def sanitize(content)
      content.split("\n").map(&:strip)
    end

    def detect_layout(lines)
      if lines[3] == BROKER_LIST[:singulare]
        'singulare'
      elsif lines[4] == BROKER_LIST[:genial]
        'genial'
      elsif lines[4] == BROKER_LIST[:clear]
        'clear'
      else
        raise UnknownLayoutError
      end
    end
  end
end

require 'baa_chan/pdf_to_text'
require 'baa_chan/parser'
require 'baa_chan/layout'
