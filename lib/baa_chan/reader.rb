# frozen_string_literal: true

require 'pdf-reader'

module BaaChan
  class Reader
    BROKER_LIST = {
      singulare: 'Singulare - corretora de titulos de valores mobiliarios'
    }

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

      case lines[4]
      when BROKER_LIST[:singulare]
        Parser::Singulare.new(lines).parse
      end
    end

    def sanitize(content)
      content.split("\n").map(&:strip)
    end
  end
end

require 'baa_chan/parser/singulare'
