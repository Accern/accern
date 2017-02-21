module Accern
  class Cli
    attr_reader :stdout, :stdin, :token, :filetype, :valid_types, :config_path,
                :options, :args, :feed, :tickers

    def initialize(stdout: $stdout, stdin: $stdin, args: [], feed: Alpha)
      @stdout = stdout
      @stdin = stdin
      @args = args
      @options = {}
      @filetype = 'json'
      @valid_types = %w(json csv)
      @config_path = "#{ENV['HOME']}/.accern.rc.yml"
      @feed = feed
      @tickers = []
    end

    def start
      load_config
      parse_options

      if options[:init]
        ask_for_info
      else
        feed.new(token: token, format: filetype.to_sym, ticker: tickers.join(','))
            .download_loop(path: './feed.jsonl')
      end
    end

    def ask_for_token
      ask_question('Please enter your API Token: ', :token)
    end

    def ask_for_filetype
      ask_question('Please enter the file type (JSON or CSV): ', :filetype)
      valid_filetype?
    end

    def load_config
      if File.exist?(config_path)
        config = YAML.load_file(config_path)
        @token = config[:token]
        @filetype = config[:filetype]
      else
        ask_for_info
      end
    end

    def parse_options
      parser = OptionParser.new do |opts|
        opts.banner = 'A command line interface for the Accern API'

        opts.on('--init', 'Display the getting started prompts.') do
          options[:init] = true
        end

        opts.on('--version', 'Show version') do
          options[:version] = Accern::VERSION
          puts Accern::VERSION
          exit
        end

        opts.on("--ticker NAME", "Filters document by ticker") do |tic|
          options[:ticker] = tic.to_s.downcase.split(',')
          @tickers += options[:ticker]
        end

        opts.on("--ticker-file PATH", "Receives the path to a file that has tickers") do |t_path|
          options[:ticker_path] = t_path
          @tickers += read_tickers(t_path)
        end
      end

      parser.parse!(args)
      @tickers.map {|t| t.gsub!(/\W/, '')}
    end

    private

    def ask_for_info
      ask_for_token
      # ask_for_filetype
      save_config
    end

    def ask_question(text, field)
      stdout.print text
      instance_variable_set(
        "@#{field}", stdin.gets.to_s.chomp.downcase.delete('.', '')
      )
    end

    def valid_filetype?
      return if valid_types.include?(filetype)
      stdout.puts 'Invalid file type, defaulting to JSON'
      @filetype = 'json'
    end

    def save_config
      config = {
        token: token,
        filetype: filetype
      }

      File.write(config_path, config.to_yaml)
      stdout.puts 'Your client is now configured and settings saved to ~/.accern.rc.yml.'
    end

    def read_tickers(path)
      return [] unless File.exist?(path)
      File.readlines(options[:ticker_path]).map { |t| t.downcase.chomp }
    end
  end
end
