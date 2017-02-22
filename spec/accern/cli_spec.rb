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

    it 'has a ticker flag' do
      generate_config
      c = Cli.new(args: ["--ticker", "amzn,aapl"])
      c.parse_options
      expect(c.options).to eq(ticker: ["amzn", "aapl"])
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


    it 'validates index value' do
      c = Cli.new(args: ['--index', 'bad500'])
      expect{c.parse_options}.to raise_error(OptionParser::InvalidArgument)
    end

    it 'receives index flag argument' do
      c = Cli.new(args: ['--index', 'sp500'])
      c.parse_options
      expect(c.indexes).to eq(['sp500'])
    end

    it 'allow multiple indexes seperated with comma' do
      c = Cli.new(args: ['--index', 'sp500,russell3000,barrons400'])
      c.parse_options
      expect(c.indexes).to eq(%w(sp500 russell3000 barrons400))
    end

    it 'accepts a index file and parse the indexes' do
      generate_index_file
      c = Cli.new(args: ['--index-file', index_file_path])
      c.parse_options
      expect(c.indexes).to eq(["sp500", "russell3000", "barrons400"])
    end

    it 'combines indexes and index file into a array' do
      generate_index_file
      c = Cli.new(args: ['--index-file', index_file_path, '--index', 'wilshire5000'])
      c.parse_options
      expect(c.indexes).to eq(["sp500", "russell3000", "barrons400", "wilshire5000"])
    end

    it 'sanitizes indexes input' do
      generate_bad_index_file
      c = Cli.new(args: ['--index-file', index_file_path, '--index', 'Wil shire-5000'])
      c.parse_options
      expect(c.indexes).to eq(["sp500", "russell3000", "barrons400", "wilshire5000"])
    end

    it 'instantiate alpha with filters' do
      generate_ticker_file
      generate_config
      args = ['--ticker-file', ticker_file_path, '--ticker', 'GOOG', '--index', 'Wil shire-5000']
      feed = spy(Alpha)
      c = Cli.new(args: args, feed: feed)
      c.start
      expect(feed).to have_received(:new).with(
      token: 'xyz', format: :json, ticker: 'aapl,fb,amzn,goog', index: "wilshire5000"
      )
      expect(feed).to have_received(:download_loop)
    end

    it 'instantiate alpha without filters' do
      generate_config
      feed = spy(Alpha)
      c = Cli.new(feed: feed)
      c.start
      expect(feed).to have_received(:new).with(
      token: 'xyz', format: :json, ticker: "", index: ''
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

    def index_file_path
      "#{@temp_directory}/index.txt"
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

    def generate_index_file
      File.open(index_file_path, 'w') do |f|
        f.puts 'sp500'
        f.puts 'russell3000'
        f.puts 'barrons400'
      end
    end

    def generate_bad_index_file
      File.open(index_file_path, 'w') do |f|
        f.puts 's&p 500'
        f.puts 'russell/3000'
        f.puts 'BarronS400'
      end
    end
  end
end
