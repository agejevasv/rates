require 'net/http'

class DownloadExchangeRates
  URL = 'http://sdw.ecb.europa.eu/quickviewexport.do?' \
        'SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'

  def self.to(output_file)
    url = URI(URL)

    response = Net::HTTP.start(url.host, url.port) do |http|
      http.request(Net::HTTP::Get.new(url))
    end

    File.open(output_file, 'w') { |file| file.write(response.body) }
  end
end