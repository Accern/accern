# Accern

A command line interface for the Accern API. Which is used for streaming the realtime data feed.

## Installation

```shell
gem install accern
```

## Usage

To get started run the `accern` command and follow the prompts.

```shell
$ accern
$ Please enter your API Token:
$ Please enter  the document format (JSON or CSV):
$ Your client is now configured and settings saved to ~/.accern.rc.yml.
```
The the next time you run `accern` the client will begin streaming the full data feed to daily files.

### File formats

The program will generate daily new line delimited JSON files ex. `2017-02-13-accern.jsonl`

## Advanced usage

To reset and bring up the getting started prompts run:

```shell
accern --init
```

### Filtering (coming soon)

You can filter by ticker by providing the ticker option.

```shell
accern --ticker appl
```
You can filter by multiple tickers by providing a comma separated list of tickers.

## Contributing

1. Create an issue and describe your idea
2. Fork it
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
