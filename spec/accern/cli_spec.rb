require 'spec_helper'

module Accern
  RSpec.describe Cli do
    it 'ask for API token' do
      expect($stdin).to receive(:gets).and_return('xyz')
      expect($stdout).to receive(:print).with(
        'Please enter your API Token: '
      )
      c = Cli.new
      c.ask_for_token
      expect(c.token).to eq('xyz')
    end

    it 'ask for file type' do
      expect($stdin).to receive(:gets).and_return('json')
      expect($stdout).to receive(:print).with(
        'Please enter the file type (JSON or CSV): '
      )
      c = Cli.new
      c.ask_for_filetype
      expect(c.filetype).to eq('json')
    end

    it 'validates file type' do
      expect($stdin).to receive(:gets).and_return('badfile')
      expect($stdout).to receive(:print).with(
        'Please enter the file type (JSON or CSV): '
      )
      expect($stdout).to receive(:puts).with(
        'Invalid file type, defaulting to JSON'
      )
      c = Cli.new
      c.ask_for_filetype
      expect(c.filetype).to eq('json')
    end

    it 'should load configuration and not display prompts' do
      generate_config
      expect($stdout).not_to receive(:print)
      c = Cli.new
      c.load_config
      expect(c.token).to eq('xyz')
      expect(c.filetype).to eq('json')
    end

    it 'should save configuration' do
      expect($stdin).to receive(:gets).and_return('abc')
      expect($stdout).to receive(:print)
      # When we add CSV support remove top line and replace with these two
      # expect($stdout).to receive(:print).twice
      # expect($stdin).to receive(:gets).and_return('csv')
      expect($stdout).to receive(:puts).with(
        'Your client is now configured and settings saved to ~/.accern.rc.yml.'
      )

      c = Cli.new
      c.load_config
      config = YAML.load_file(config_path)

      expect(config[:token]).to eq('abc')
      expect(config[:filetype]).to eq('json')
      # replace above when we add csv support
      # expect(config[:filetype]).to eq('csv')
    end

    it 'has a init flag' do
      c = Cli.new(args: ['--init'])
      c.parse_options
      expect(c.options).to eq(init: true)
    end

    it 'has a version flag' do
      generate_config
      c = Cli.new(args: ['--version'])
      expect do
        begin
          c.parse_options
        rescue SystemExit
          # handling for the test cases to continue
        end
      end.to output("#{VERSION}\n").to_stdout
      expect(c.options).to eq(version: VERSION)
    end

    it 'implements init flag' do
      expect($stdin).to receive(:gets).and_return('abc')
      expect($stdout).to receive(:print)
      # When we add CSV support remove top line and replace with these two
      # expect($stdout).to receive(:print).twice
      # expect($stdin).to receive(:gets).and_return('json')
      expect($stdout).to receive(:puts).with(
        'Your client is now configured and settings saved to ~/.accern.rc.yml.'
      )
      generate_config
      c = Cli.new(args: ['--init'])

      c.start
      expect(c.options).to eq(init: true)
    end

    it 'formats ticker into a array' do
      c = Cli.new(args: ['--ticker', 'aapl'])
      c.parse_options
      expect(c.tickers).to eq(['aapl'])
    end

    it 'reads the ticker file and formats into a array' do
      generate_ticker_file
      c = Cli.new(args: ['--ticker-file', ticker_file_path])
      c.parse_options
      expect(c.tickers).to eq(%w(aapl fb amzn))
    end

    it 'combines ticker and ticker file into a array' do
      generate_ticker_file
      c = Cli.new(args: ['--ticker-file', ticker_file_path, '--ticker', 'GOOG'])
      c.parse_options
      expect(c.tickers).to eq(%w(aapl fb amzn goog))
    end

    it 'sanitizes ticker and ticker file input' do
      generate_bad_ticker_file
      c = Cli.new(args: ['--ticker-file', ticker_file_path, '--ticker', 'GOOG'])
      c.parse_options
      expect(c.tickers).to eq(%w(aapl fb amzn goog))
    end

    it 'calls the Accern API' do
      generate_ticker_file
      generate_config
      args = ['--ticker-file', ticker_file_path, '--ticker', 'GOOG']
      feed = spy(Alpha)
      c = Cli.new(args: args, feed: feed)
      c.start
      expect(feed).to have_received(:new).with(
        token: 'xyz', format: :json, ticker: 'aapl,fb,amzn,goog'
      )
      expect(feed).to have_received(:download_loop)
    end

    it 'passes the correct values to Alpha' do
      generate_ticker_file
      generate_config
      feed = spy(Alpha)
      c = Cli.new(feed: feed)
      c.start
      expect(feed).to have_received(:new).with(
        token: 'xyz', format: :json, ticker: ""
      )
      expect(feed).to have_received(:download_loop)
    end

    private

    def generate_config
      config = {
        token: 'xyz',
        filetype: 'json'
      }

      File.write(config_path, config.to_yaml)
    end

    def config_path
      "#{@temp_directory}/.accern.rc.yml"
    end

    def ticker_file_path
      "#{@temp_directory}/tickers.txt"
    end

    def generate_ticker_file
      File.open(ticker_file_path, 'w') do |f|
        f.puts 'aapl'
        f.puts 'fb'
        f.puts 'amzn'
      end
    end

    def generate_bad_ticker_file
      File.open(ticker_file_path, 'w') do |f|
        f.puts 'aa pl '
        f.puts 'fb.'
        f.puts 'AMZn'
      end
    end
  end
end
