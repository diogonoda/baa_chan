# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'baa_chan'
  s.version     = '0.0.0'
  s.summary     = 'Trade Confirmation Reader'
  s.description = <<~DESC
    BaaChan will read your trade confirmations and provide you
    details about your trades helping you out handling your
    finances
  DESC
  s.authors     = ['Diogo Noda']
  s.email       = 'diogotnoda@gmail.com'
  s.files       = Dir.glob('{examples,lib}/**/**/*')
  s.homepage    = 'https://rubygems.org/gems/baa_chan'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  s.add_development_dependency 'pry', '~> 0.14.1'
  s.add_development_dependency 'rspec', '~> 3.10.0'

  s.add_dependency 'pdf-reader', '~> 2.4.2'
end
