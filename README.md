[![Gem Version](https://badge.fury.io/rb/accern@2x.png)](https://badge.fury.io/rb/accern)
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
$ Your client is now configured and settings saved to ~/.accern.rc.yml.
```
The the next time you run `accern` the client will begin streaming the full data feed to `./feed.jsonl`

## Advanced usage

To reset and bring up the getting started prompts run:

```shell
accern --init
```

## Contributing

1. Create an issue and describe your idea
2. Fork it
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
