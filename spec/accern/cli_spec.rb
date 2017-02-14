require 'spec_helper'

module Accern
  RSpec.describe Cli do
    it 'ask for API token' do
      c = cli_with_io('xyz')
      c.ask_for_token
      expect(c.stdout.string.chomp).to eq('Please enter your API Token:')
      expect(c.token).to eq('xyz')
    end

    it 'ask for file type' do
      c = cli_with_io('json')
      c.ask_for_filetype
      expect(c.stdout.string.chomp).to eq(
        'Please enter the file type (JSON or CSV):'
      )
      expect(c.filetype).to eq('json')
    end

    it 'validates file type' do
      c = cli_with_io('badfile')
      c.ask_for_filetype
      expect(c.stdout.string.chomp.split("\n").last).to eq(
        'Invalid file type, defaulting to JSON'
      )
      expect(c.filetype).to eq('json')
    end

    it 'should load configuration' do
      generate_config
      c = cli_with_io
      c.start

      expect(c.token).to eq('xyz')
      expect(c.filetype).to eq('json')
    end

    it 'does not display prompt when settings file exists' do
      generate_config
      c = cli_with_io
      c.start
      expect(c.stdout.string.chomp).to eq('')
    end

    it 'should save configuration' do
      c = cli_with_io("abc\ncsv\n")
      c.start
      config = YAML.load_file(config_path)

      expect(config[:token]).to eq('abc')
      expect(config[:filetype]).to eq('csv')
      expect(c.stdout.string.chomp.split("\n").last).to eq(
        'Your client is now configured and settings saved to ~/.accern.rc.yml.'
      )
    end

    it 'has a init flag' do
      generate_config
      c = cli_with_io("abc\njson\n", ['--init'])
      c.start
      expect(c.options).to eq(init: true)
    end

    it 'implements init flag' do
      generate_config
      c = cli_with_io("abc\njson\n", ['--init'])
      c.start

      expect(c.options).to eq(init: true)
      expect(c.stdout.string.split("\n").first.to_s.chomp).to eq(
        'Please enter your API Token:'
      )
    end

    it 'has a version flag' do
      generate_config
      c = Cli.new(args: ['--version'])
      c.start
      expect(c.options).to eq(version: VERSION)
    end

    private

    def cli_with_io(text = '', args = [])
      output = StringIO.new
      input = StringIO.new(text)
      Cli.new(stdout: output, stdin: input, args: args)
    end

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
  end
end
