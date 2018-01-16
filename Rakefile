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


task :compile => [:clean, 'lib/anystyle/data/dict.txt.gz']

file 'lib/anystyle/data/dict.txt.gz' => FileList['res/*.txt'] do |f|
  entries = {}
  f.prerequisites.each do |file|
    cat = ''
    File.foreach(file, encoding: "UTF-8") do |line|
      case line
      when /^#! (\w+)/ # Get current category
        cat = $1
        entries[cat] ||= []
      when /^#/ # Discard
      else
        # Only first word per line is token
        token = line.split(/\s+(\d+\.\d+)\s*$/)[0]
        # Strip punctuation and whitespace at start and end
        token.gsub!(/^[\p{P}\p{S}\s]+|[\p{P}\p{S}\s]+$/, '')
        # Replace characters with diacritic marks with their base equivalent
        token.unicode_normalize!(:nfkd)
        token.gsub!(/\p{M}/, '')
        # Get rid of special characters likes apostrophes
        token.gsub!(/\p{Lm}/, '')
        token.downcase!
        # Split words on punctuation and keep all pieces that are at least 3 characters long
        # as well as the original word with all punctuation removed
        pieces = token.split(/[\p{P}\p{S}]/)
        pieces << token.gsub(/[\p{P}\p{S}]/, '') if pieces.count > 1
        pieces.each { |piece| entries[cat] << piece if piece.length >= 3 && piece =~ /\p{L}/ }
      end
    end
  end

  require 'zlib'
  Zlib::GzipWriter.open(f.name) do |zip|
    entries.each do |cat, items|
      zip.puts "#! #{cat}"
      items.uniq.sort.each { |i| zip.puts i }
    end
  end
end
