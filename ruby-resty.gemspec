# -*- encoding: utf-8 -*-

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'ruby-resty'
  gem.version       = Resty::VERSION
  gem.authors       = ['Austen Ito']
  gem.email         = ['austen.dev@gmail.com']
  gem.homepage      = ''
  gem.summary       = ''
  gem.description   = gem.summary
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']
  gem.executables   << 'ruby-resty'

  gem.add_dependency 'active_support'
  gem.add_dependency 'pry'
  gem.add_dependency 'rest-client', '1.6.7'
  gem.add_dependency 'trollop'
  gem.add_dependency 'multi_json'

  gem.add_development_dependency 'bourne', "1.4.0"
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'mocha', "~> 0.13"
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sinatra'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end
