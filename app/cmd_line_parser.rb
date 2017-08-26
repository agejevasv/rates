require 'optparse'
require 'ostruct'

class CmdLineParser
  private_class_method :new
  attr_reader :options

  def initialize
    @options = OpenStruct.new
  end

  def self.parse(args)
    cmd_parser = new
    cmd_parser.parser.parse!(args)
    cmd_parser.options
  rescue OptionParser::ParseError => e
    $stderr.print "Error: #{e.message}"
    exit -1
  end

  def parser
    OptionParser.new do |opts|
      opts.banner = 'Usage: ruby rates.rb [options]'

      opts.on('-u', '--update',
        'Update exchange conversion rates data file') do |update|
        @options.update = update
      end

      opts.on('-a', '--amount DECIMAL',
        'Amount of money in USD to convert to EUR') do |amount|
        @options.amount = amount
      end

      opts.on('-d', '--date YYYY-MM-DD',
        'Use exchange rate at this date for this conversion, ' \
        'defaults to newest conversion rate date available') do |date|
        @options.date = date
      end

      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end
  end
end
