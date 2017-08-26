require_relative './app/cmd_line_parser'
require_relative './app/download_exchange_rates'
require_relative './app/currency_exchange'

EXCHANGE_RATES_FILE = File.join(File.dirname(__FILE__), 'data/rates.csv')

begin
  cmd_line = CmdLineParser.parse(ARGV.any? ? ARGV : ['-h'])

  if cmd_line.update
    DownloadExchangeRates.to(EXCHANGE_RATES_FILE)
    puts 'Exchange rates were successfuly updated'
  end

  exit unless cmd_line.amount

  exchange = CurrencyExchange.new(EXCHANGE_RATES_FILE)

  puts "%s USD = %.2f EUR on %s" % [
    cmd_line.amount,
    exchange.convert(cmd_line.amount, cmd_line.date),
    cmd_line.date || exchange.upper_date
  ]
rescue ArgumentError => e
  $stderr.print "Error: #{e.message || 'Wrong input data'}"
  exit -1
end

