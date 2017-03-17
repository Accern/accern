[![Gem Version](https://badge.fury.io/rb/accern.svg)](https://badge.fury.io/rb/accern)

# Accern

A command line interface for the Accern API. Which is used for streaming the realtime data feed.

## Installation

```shell
# default macOS Ruby
$ sudo gem install accern

# When using a Ruby version manager
$ gem install accern
```

## Usage

To get started run the `accern` command and follow the prompts.

```shell
$ accern
$ Please enter your API Token:
$ Your client is now configured and settings saved to ~/.accern.rc.yml.
```
The the next time you run `accern` the client will begin streaming the full data feed to `./feed.jsonl`

## Advanced usage

To reset and bring up the getting started prompts run:

```shell
$ accern --init
```

### Filter by ticker

```shell
# single ticker
$ accern --ticker appl

# multiple tickers
$ accern --ticker "appl,amzn"
```

### Filter by ticker file
Create a newline delimited ticker file:

```
appl
amzn
```

```shell
$ accern --ticker-file ./my_tickers.txt
```

### Filter by index

The index value must be one of the following values

index					 | expected value
-----------------|----------------------
S&P 500				| sp500
Russell 1000		| russell1000
Russell 3000		| russell3000
Wilshire 5000		| wilshire5000
Barron's 400		| barrons400
DOW 30				| dow30

```shell
# single index
$ accern --index sp500

# multiple indexes
$ accern --index "dow30,russell1000"
```

### Filter by index file
Create a newline delimited index file with the any of the allowed values:

```
dow30
sp500
```

```shell
$ accern --index-file ./my_indexes.txt
```

## Contributing

1. Create an issue and describe your idea
2. Fork it
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
