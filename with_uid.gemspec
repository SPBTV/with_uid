# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'with_uid/version'

Gem::Specification.new do |spec|
  spec.name          = 'with_uid'
  spec.version       = WithUid::VERSION
  spec.authors       = ['TODO: Write your name']
  spec.email         = ['abolshakov@spbtv.com']
  spec.summary       = 'TODO: Write a short summary. Required.'
  spec.description   = 'TODO: Write a longer description. Optional.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4'
  spec.add_dependency 'activemodel', '>= 4'
  spec.add_development_dependency 'activerecord', '~> 4.2'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
