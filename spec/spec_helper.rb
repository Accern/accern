require 'bundler/setup'
require 'tmpdir'
require 'fileutils'
require 'pry'
require 'accern'

ENV['RUBY_ENV'] = 'test'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = 'random'

  config.before(:each) do
    @temp_directory =
      Dir.mktmpdir(
        'test_home', File.expand_path('./', __dir__)
      )

    @original_home_path = ENV['HOME']
    ENV['HOME'] = @temp_directory
  end

  config.after(:each) do
    ENV['HOME'] = @original_home_path
    FileUtils.rm_r @temp_directory
  end
end
