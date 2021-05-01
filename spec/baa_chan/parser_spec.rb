# frozen_string_literal: true

RSpec.describe BaaChan::Parser do
  context 'when parsing Singulare trade confirmation' do
    let(:dummy_line) { 'Singulare - corretora de titulos de valores mobiliarios' }
    let(:lines) { [dummy_line] }
    let(:layout) { Layout.new('singulare') }

    context 'when there are two trades' do
      context 'when parsing trade data' do
        let(:first_trade_line) do
          'BM&FBOVESPA S/A.      V   OPCAO DE       02/20      PETRB337               PN 32,95'\
          '          100       0,100000                    8,00   C'
        end
        let(:second_trade_line) do
          'BM&FBOVESPA S/A.      V   OPCAO DE       02/20      VALEB635               ON 62,30'\
          '          200       0,290000                   58,00   C'
        end

        before do
          lines.push(first_trade_line, second_trade_line)

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

    context 'when parsing costs data' do
      let(:brokerage_line) do
        'Corretagem                                                                      7,00         D'
      end
      let(:clearing_fee_line) do
        "Compras à Vista                                                                    0,00\
        Taxa de Liquidação                                                              0,06         D"
      end
      let(:registration_fee_line) do
        "Opções - Compras                                                                   0,00\
        Taxa de Registro                                                                0,15         D"
      end
      let(:emoluments_line) do
        "Ajuste da Posição                                                                  0,00\
        Emolumentos                                                                     0,08         D"
      end
      let(:iss_line) do
        'ISS (SAO PAULO)                                                                 0,35'
      end
      let(:irrf_line) do
        "A coluna \"Q\" indica liquidação no Agente Qualificado\
        I.R.R.F. s/ operações, base R$ 224,00                                           0,01"
      end

      before do
        lines.push(brokerage_line, clearing_fee_line, registration_fee_line, emoluments_line,
                   iss_line, irrf_line)

        @costs = BaaChan::CostsParser.new(lines, layout).parse
      end

      it 'returns costs details' do
        expect(@costs.brokerage).to eq 7.0
        expect(@costs.clearing_fee).to eq 0.06
        expect(@costs.registration_fee).to eq 0.15
        expect(@costs.emoluments).to eq 0.08
        expect(@costs.iss).to eq 0.35
        expect(@costs.irrf).to eq 0.01
      end
    end

    context 'when some cost is not found' do
      before do
        @costs_parser = BaaChan::CostsParser.new(lines, layout)
      end

      it 'return an CostsParserError' do
        expect { @costs_parser.parse }.to raise_error(BaaChan::CostsParserError)
      end
    end
  end

  context 'when parsing genial trades confirmation' do
    let(:dummy_line) { 'GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIÁRIOS S.A.' }
    let(:lines) { [dummy_line] }
    let(:layout) { Layout.new('genial') }

    context 'when parsing trades data' do
      let(:fii_trade_line) do
        '1-BOVESPA               C    VISTA                                                FII HSI MALL CI ER'\
        '                   10                     88,45                     884,50                         D'
      end
      let(:stock_trade_line) do
        '1-BOVESPA               C    VISTA                                                PETROBRAS PN             N2'\
        '                             200                    13,30                    2.660,00                       D'
      end
      let(:option_trade_line) do
        '1-BOVESPA               V    OPCAO DE COMPRA                            05/20     PETRE192 PN 19,22 PETR'\
        '                        1.700                  0,25                     425,00                         C'
      end

      before do
        lines.push(fii_trade_line, stock_trade_line, option_trade_line)

        @trades = BaaChan::TradeParser.new(lines, layout).parse
      end

      it 'returns trades details' do
        expect(@trades.size).to eq 3

        fii_trade = @trades.first

        expect(fii_trade.operation).to eq 'Buy'
        expect(fii_trade.price).to eq 88.45
        expect(fii_trade.quantity).to eq 10
        expect(fii_trade.ticker).to eq 'FII HSI MALL CI ER'

        stock_trade = @trades[1]

        expect(stock_trade.price).to eq 13.3

        option_trade = @trades[2]

        expect(option_trade.ticker).to eq 'PETRE192 PN 19,22 PETR'
      end
    end
  end

  context 'when parsing clear trades confirmation' do
    let(:dummy_line) { 'CLEAR CORRETORA - GRUPO XP' }
    let(:lines) { [dummy_line] }
    let(:layout) { Layout.new('clear') }

    context 'when parsing trades data' do
      let(:stock_trade_line) do
        '1-BOVESPA                    C VISTA                                          ITAUUNIBANCO'\
        '     ON ED N1              100                30,76                             3.076,00 D'
      end

      before do
        lines.push(stock_trade_line)

        @trades = BaaChan::TradeParser.new(lines, layout).parse
      end

      it 'returns trades details' do
        expect(@trades.size).to eq 1

        stock_trade = @trades.first

        expect(stock_trade.operation).to eq 'Buy'
        expect(stock_trade.price).to eq 30.76
        expect(stock_trade.quantity).to eq 100
        expect(stock_trade.ticker).to eq 'ITAUUNIBANCO'
      end
    end
  end
end
