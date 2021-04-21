# frozen_string_literal: true

require 'English'

module BaaChan
  class UnreadablePDFError < StandardError; end

  class InvalidExtensionError < StandardError; end

  class PdfToText
    def self.call(source)
      raise InvalidExtensionError unless source.match /\.pdf$/

      content = `pdftotext -layout #{source} -`

      raise UnreadablePDFError unless $CHILD_STATUS.success?

      content
    end
  end
end
