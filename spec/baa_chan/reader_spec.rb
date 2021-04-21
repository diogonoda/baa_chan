# frozen_string_literal: true

RSpec.describe BaaChan::Reader do
  context '.success' do
    context 'when it is a Singulare trade confirmation' do
      let(:page_content) { file_fixture('singulare_content.txt').read }

      subject { BaaChan::Reader.new('foo') }

      before do
        allow(BaaChan::PdfToText).to receive(:call).with('foo').and_return(page_content)

        @trade_confirmation = subject.call
      end

      it 'returns a TradeConfirmation' do
        expect(@trade_confirmation.broker).to eq 'Singulare - corretora de titulos de valores mobiliarios'
        expect(@trade_confirmation.trade_confirmation_number).to eq '12345'
        expect(@trade_confirmation.trade_date).to eq(Date.new(2021, 1, 1))
      end

      it 'contains details of trades' do
        first_trade = @trade_confirmation.trades.first

        expect(first_trade.operation).to eq 'Sell'
        expect(first_trade.price).to eq 0.28
        expect(first_trade.quantity).to eq 800
        expect(first_trade.ticker).to eq 'PETRD192'
      end

      it 'contains details of costs' do
        total_costs = @trade_confirmation.costs

        expect(total_costs.brokerage).to eq 7.0
        expect(total_costs.clearing_fee).to eq 0.06
        expect(total_costs.emoluments).to eq 0.08
        expect(total_costs.irrf).to eq 0.01
        expect(total_costs.iss).to eq 0.35
        expect(total_costs.registration_fee).to eq 0.15
        expect(total_costs.pis_cofins).to eq 0.00
      end
    end

    context 'when it is a Genial trade confirmation' do
      let(:page_content) { file_fixture('genial_content.txt').read }

      subject { BaaChan::Reader.new('foo') }

      before do
        allow(BaaChan::PdfToText).to receive(:call).with('foo').and_return(page_content)

        @trade_confirmation = subject.call
      end

      it 'returns a TradeConfirmations list' do
        expect(@trade_confirmation.broker).to eq 'GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIÁRIOS S.A.'
        expect(@trade_confirmation.trade_confirmation_number).to eq '123'
        expect(@trade_confirmation.trade_date).to eq(Date.new(2021, 1, 1))
      end

      it 'contains details of trades' do
        first_trade = @trade_confirmation.trades.first

        expect(first_trade.operation).to eq 'Buy'
        expect(first_trade.price).to eq 13.30
        expect(first_trade.quantity).to eq 200
        expect(first_trade.ticker).to eq 'PETROBRAS'
      end

      it 'contains details of costs' do
        total_costs = @trade_confirmation.costs

        expect(total_costs.brokerage).to eq 5.0
        expect(total_costs.clearing_fee).to eq 0.73
        expect(total_costs.emoluments).to eq 0.18
        expect(total_costs.irrf).to eq 0.00
        expect(total_costs.iss).to eq 0.25
        expect(total_costs.registration_fee).to eq 0.00
        expect(total_costs.pis_cofins).to eq 0.48
      end
    end
  end

  context '.error' do
    context 'when layout not available' do
      let(:invalid_layout) { 'anything' }

      subject { BaaChan::Reader.new('foo') }

      before do
        allow(BaaChan::PdfToText).to receive(:call).with('foo').and_return(invalid_layout)
      end

      it 'returns unknown layout error' do
        expect { subject.call }.to raise_error(BaaChan::UnknownLayoutError)
      end
    end
  end
end
