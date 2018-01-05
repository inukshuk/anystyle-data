require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle` to install missing gems!"
  exit e.status_code
end

require 'rake'
require 'rake/clean'

CLEAN.include('*.gem')
CLEAN.include('lib/anystyle/data/dict.txt.gz')

task :compile => [:clean] do
  require 'zlib'
  # TODO combine txt files in res
end
