# USD to EUR exchange calculator
This is a little command line util to convert currency in USD to EUR.

## Installation
```
git clone git@github.com:electrotek/rates.git
cd rates
```

## Examples
```
ruby rates.rb -u -a 120 -d 2017-01-01
Exchange rates were successfuly updated
120 USD = 113.84 EUR on 2017-01-01

# Without date option, the application will use the newest rate available, e.g. on 2017-08-26 output is:
ruby rates.rb -a 42.42
42.42 USD = 35.92 EUR on 2017-08-25
```

## Usage
```
Usage: ruby rates.rb [options]
    -u, --update                     Update exchange conversion rates data file
    -a, --amount DECIMAL             Amount of money in USD to convert to EUR
    -d, --date YYYY-MM-DD            Use exchange rate at this date for this conversion, defaults to newest conversion rate date available
    -h, --help                       Show this message
```

## Run specs
```
bundle install
rspec
```
