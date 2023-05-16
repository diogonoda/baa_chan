# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'baa_chan'
  s.version     = '0.0.2'
  s.executables << 'baa_chan'
  s.summary     = 'Trade Confirmation Reader'
  s.description = <<~DESC
    BaaChan will read your trade confirmations and provide you
    details about your trades helping you out handling your
    finances
  DESC
  s.authors     = ['Diogo Noda']
  s.email       = 'diogotnoda@gmail.com'
  s.files       = Dir.glob('{examples,lib}/**/**/*')
  s.homepage    = 'https://github.com/diogonoda/baa_chan'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0.0'
  s.metadata = {
    'source_code_uri' => 'https://github.com/diogonoda/baa_chan'
  }

  s.add_development_dependency 'pry-byebug', '~> 3.9.0'
  s.add_development_dependency 'rspec', '~> 3.12.0'
  s.add_development_dependency 'simplecov', '~> 0.16.1'
  s.add_development_dependency 'coveralls', '~> 0.8.23'

  s.add_dependency 'jbuilder', '~> 2.11.2'
end
