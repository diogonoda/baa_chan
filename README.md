# Baa_chan

BaaChan is kind and knows you have a lot to do. She's here to help you out
reading the details of your trade confirmations.

## Installation

~~~ruby
gem install baa_chan
~~~

## Usage

BaaChan expects your trade confirmation input as a PDF file. Details
about each page of your trades becomes available for you as a
`BaaChan::TradeConfirmation` object

~~~ruby
pages = BaaChan::Reader.new('your_trade_confirmation_path.pdf').call

pages.each do |page|
  puts page.broker
  puts page.trade_date

  page.trades.each do |trade|
    puts trade.operation
    puts trade.ticker
    puts trade.quantity
    puts trade.price
  end

  page.costs.each do |cost|
    puts cost.brokerage
    puts cost.clearing_fee
    puts cost.emoluments
    puts cost.irrf
    puts cost.iss
    puts cost.registration_fee
  end
end
~~~

# TODO

* Include more brokerages layouts (Clear, Easynvest, XP, ...)
* Improve rspec coverage
* Code Climate and coverage badges
* Allow users to overwrite layouts
* Trade Confirmations with multiple pages
* Allow calculating or spreading costs between trades

## Licensing

This library is distributed under the terms of the MIT License. See the included file for
more detail.

## Maintainers

* Diogo Noda
