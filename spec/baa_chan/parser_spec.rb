# frozen_string_literal: true

RSpec.describe BaaChan::Parser do
  context 'when parsing Singulare trade confirmation' do
    context 'when there is two trades' do
      let(:first_trade_line) do
        'BM&FBOVESPA S/A.      V   OPCAO DE       02/20      PETRB337               PN 32,95\
        100       0,100000                    8,00   C'
      end
      let(:second_trade_line) do
        'BM&FBOVESPA S/A.      V   OPCAO DE       02/20      VALEB635               ON 62,30\
        200       0,290000                   58,00   C'
      end
      let(:dummy_line) { 'Singulare - corretora de titulos de valores mobiliarios' }
      let(:lines) { [dummy_line, first_trade_line, second_trade_line] }
      let(:layout) { Layout.new('singulare') }

      before do
        @trades = BaaChan::TradeParser.new(lines, layout).parse
      end

      it 'returns two trade objects' do
        expect(@trades.size).to eq 2

        first_trade = @trades.first

        expect(first_trade.operation).to eq 'Sell'
        expect(first_trade.price).to eq 0.1
        expect(first_trade.quantity).to eq 100
        expect(first_trade.ticker).to eq 'PETRB337'

        second_trade = @trades[1]

        expect(second_trade.operation).to eq 'Sell'
        expect(second_trade.price).to eq 0.29
        expect(second_trade.quantity).to eq 200
        expect(second_trade.ticker).to eq 'VALEB635'
      end
    end
  end
end
