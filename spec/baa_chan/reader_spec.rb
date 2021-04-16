# frozen_string_literal: true

RSpec.describe BaaChan::Reader do
  context 'when it is a Singulare trade confirmation' do
    let(:page_content) { file_fixture('singulare_content.txt').read }
    let(:page_text) { instance_double(PDF::Reader::Page, text: page_content) }
    let(:pdfs) { instance_double(PDF::Reader, pages: [page_text]) }

    subject { BaaChan::Reader.new('foo') }

    before do
      allow(PDF::Reader).to receive(:new).with('foo').and_return(pdfs)

      @trade_confirmations = subject.call
    end

    it 'returns a TradeConfirmations list' do
      expect(@trade_confirmations.size).to eq 1

      first_page = @trade_confirmations.first

      expect(first_page.broker).to eq 'Singulare - corretora de titulos de valores mobiliarios'
      expect(first_page.trade_confirmation_number).to eq '12345'
      expect(first_page.trade_date).to eq(Date.new(2021, 4, 1))
    end

    it 'contains details of trades' do
      first_trade = @trade_confirmations.first.trades.first

      expect(first_trade.operation).to eq 'Sell'
      expect(first_trade.price).to eq 0.28
      expect(first_trade.quantity).to eq 800
      expect(first_trade.ticker).to eq 'PETRD192'
    end

    it 'contains details of costs' do
      total_costs = @trade_confirmations.first.costs

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
    let(:page_text) { instance_double(PDF::Reader::Page, text: page_content) }
    let(:pdfs) { instance_double(PDF::Reader, pages: [page_text]) }

    subject { BaaChan::Reader.new('foo') }

    before do
      allow(PDF::Reader).to receive(:new).with('foo').and_return(pdfs)

      @trade_confirmations = subject.call
    end

    it 'returns a TradeConfirmations list' do
      expect(@trade_confirmations.size).to eq(1)

      first_page = @trade_confirmations.first

      expect(first_page.broker).to eq 'GENIAL INVESTIMENTOS CORRETORA DE VALORES MOBILIÁRIOS S.A.'
      expect(first_page.trade_confirmation_number).to eq '12'
      expect(first_page.trade_date).to eq(Date.new(2021, 3, 27))
    end

    it 'contains details of trades' do
      first_trade = @trade_confirmations.first.trades.first

      expect(first_trade.operation).to eq 'Buy'
      expect(first_trade.price).to eq 13.30
      expect(first_trade.quantity).to eq 200
      expect(first_trade.ticker).to eq 'PETROBRAS'
    end

    it 'contains details of costs' do
      total_costs = @trade_confirmations.first.costs

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
