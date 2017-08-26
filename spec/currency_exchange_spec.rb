
require_relative '../app/currency_exchange'
require 'bigdecimal'
require 'date'

RSpec.describe CurrencyExchange do
  describe '#convert' do
    let(:amount) { '42.42' }
    let(:exchange) { described_class.new('./data/rates.csv') }
    let(:upper_date) { '2017-08-25' }
    let(:lower_date) { '1999-01-04' }
    let(:fallback_date) { '2017-08-06' }

    subject(:convert) { exchange.convert(amount, date) }

    context 'for existing rate' do
      let(:date) { '2017-08-25' }
      let(:rate) { BigDecimal.new('1.1808') }

      it 'converts given amount in USD to EUR' do
        expect(convert).to eq((BigDecimal.new(amount) / rate).round(2))
      end
    end

    context 'without date value' do
      let(:date) { nil }
      let(:rate) { BigDecimal.new('1.1808') }

      it 'converts given amount using latest rate' do
        expect(convert).to eq((BigDecimal.new(amount) / rate).round(2))
      end
    end

    context 'converting for non existing date' do
      context 'above upper bound' do
        let(:date) { Date.parse(upper_date).next_day.to_s }

        it 'raises error' do
          expect { convert }.to raise_error(ArgumentError)
        end
      end

      context 'below lower bound' do
        let(:date) { Date.parse(lower_date).prev_day.to_s }

        it 'raises error' do
          expect { convert }.to raise_error(ArgumentError)
        end
      end
    end

    context 'for bank holiday date' do
      let(:date) { fallback_date }
      let(:fallback_rate) { BigDecimal.new('1.1868') }

      it 'uses previous available rate' do
        expect(convert).to eq((BigDecimal.new(amount) / fallback_rate).round(2))
      end
    end
  end
end
