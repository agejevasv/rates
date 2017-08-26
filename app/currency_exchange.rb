require 'date'
require 'bigdecimal'

class CurrencyExchange
  attr_reader :upper_date, :lower_date

  def initialize(data_file)
    @source = data_file

    raise ArgumentError.new(
      'Exchange rates file does not exist'
    ) unless File.exists?(@source)

    import
  end

  def convert(amount, date = nil)
    date = date ? Date.parse(date) : @upper_date
    validate(date)
    (BigDecimal.new(amount) / rate_at_date(date)).round(2)
  end

  private

  def validate(date)
    raise ArgumentError.new(
      'Sorry, can\'t see into the future...'
    ) if date > Date.today

    raise ArgumentError.new(
      "No rates data for given date, the lowest supported date is #{lower_date}"
    ) if date < lower_date

    raise ArgumentError.new(
      'No rates data for given date, try to update exchange rates'
    ) if date > upper_date
  end

  def import
    @rates = File.open(@source, 'r').map do |line|
      next unless line =~ /^\d/
      date, rate = line.split(',')
      @lower_date = Date.parse(date)
      @upper_date ||= Date.parse(date)

      rate.to_f > 0 ? [date, rate.strip] : nil
    end.compact.to_h

    raise ArgumentError.new(
      'Conversion rates data file is erroneous'
    ) unless @lower_date && @upper_date
  end

  def rate_at_date(date)
    loop do
      return BigDecimal.new(@rates[date.to_s]) if @rates.key?(date.to_s)
      date -= 1
    end
  end
end
