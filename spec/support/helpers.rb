# frozen_string_literal: true

module Helpers
  def file_fixture(path)
    File.open("spec/fixtures/#{path}")
  end
end
