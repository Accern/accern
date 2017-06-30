# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'accern/version'

Gem::Specification.new do |spec|
  spec.name          = 'accern'
  spec.version       = Accern::VERSION
  spec.authors       = ['Carlos Espejo', 'Kerry Imai']
  spec.email         = ['vendors@accern.com']
  spec.summary       = 'A command line interface for the Accern API.'
  spec.homepage      = 'https://github.com/Accern/accern'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  # spec.add_development_dependency 'guard-rspec', '~> 4.7'
end
