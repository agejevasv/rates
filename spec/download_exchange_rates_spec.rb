
require_relative '../app/download_exchange_rates'
require 'ostruct'

RSpec.describe DownloadExchangeRates do
  describe '.to' do
    let(:filename) { '/tmp/rates.csv' }
    let(:contents) { 'whatever' }

    before do
      expect(Net::HTTP).to(
        receive(:start).and_return(OpenStruct.new(body: contents))
      )
    end

    specify 'downloads the rates to given file' do
      DownloadExchangeRates.to(filename)
      expect(File.exists?(filename)).to be(true)
      expect(File.read(filename)).to eq(contents)
    end
  end
end
