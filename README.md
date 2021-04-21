# Baa_chan

BaaChan is kind and knows you have a lot to do. She's here to help you out
reading the details of your trade confirmations.

## Installation

~~~ruby
gem install baa_chan
~~~

BaaChan depends on `pdftotext` lib. If you're a Linux user probably you won't worry about it.
You can check availability with:
~~~shell
pdftotext -v
~~~
Otherwise, https://poppler.freedesktop.org/

## Usage

BaaChan expects your trade confirmation input as a PDF file. Details
about each page of your trades becomes available for you as a
`BaaChan::TradeConfirmation` object

~~~ruby
trade_confirmation = BaaChan::Reader.new('your_trade_confirmation_path').call

trade_confirmation.tap do |tc|
  puts tc.broker
  puts tc.trade_date

  tc.trades.each do |trade|
    puts trade.operation
    puts trade.ticker
    puts trade.quantity
    puts trade.price
  end

  tc.costs.tap do |cost|
    puts cost.brokerage
    puts cost.clearing_fee
    puts cost.registration_fee
    puts cost.emoluments
    puts cost.irrf
    puts cost.iss
    puts cost.pis_cofins
  end
end
~~~


You can also run it from your terminal and get a json version of your
trade confirmation. In this case you could use [jq](https://stedolan.github.io/jq/)
or some related tool to have a prettier and readable output

~~~shell
baa_chan <your_trade_confirmation_path> | jq
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
