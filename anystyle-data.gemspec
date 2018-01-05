# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'anystyle/data/version'

Gem::Specification.new do |s|
  s.name        = 'anystyle-data'
  s.version     = AnyStyle::Data::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = ['http://sylvester.keil.or.at']
  s.homepage    = 'http://anystyle.io'
  s.summary     = 'AnyStyle parser dictionary data'
  s.license     = 'BSD-2-Clause'

  s.files        = `git ls-files`.split("\n").reject { |path|
    path.start_with?('.')
  } - Dir['res/**/*']

  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'
end

# vim: syntax=ruby
