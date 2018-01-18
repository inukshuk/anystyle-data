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

DATA = 'lib/anystyle/data'

CLEAN.include('*.gem')
CLEAN.include("#{DATA}/dict.txt")
CLEAN.include("#{DATA}/dict.txt.gz")

task :compile => ["#{DATA}/dict.txt.gz"]

rule '.txt.gz' => '.txt' do |t|
  require 'zlib'
  Zlib::GzipWriter.open(t.name) do |zip|
    zip.mtime = File.mtime(t.source)
    zip.orig_name = t.source
    zip.write IO.binread(t.source)
  end
  puts "#{File.stat(t.name).size / 1024}k compressed"
end

file "#{DATA}/dict.txt" => FileList['res/*.txt'] do |t|
  dict = {}

  puts "Compiling dictionary from #{t.prerequisites.size} sources ..."
  t.prerequisites.each do |file|
    cat = ''
    puts " <- #{File.basename(file)}"
    File.foreach(file, encoding: 'UTF-8') do |line|
      case line
      when /^#! (\w+)/
        cat = $1
        dict[cat] ||= []
      when /^#/
        # discard comments...
      else
        # Only first word per line is token
        token = line.split(/\s+(\d+\.\d+)\s*$/)[0]

        # Strip punctuation and whitespace at start and end
        token.gsub!(/^[\p{P}\p{S}\s]+|[\p{P}\p{S}\s]+$/, '')

        # Replace characters with diacritic marks
        # with their base equivalent
        token.unicode_normalize!(:nfkd)
        token.gsub!(/\p{M}/, '')

        # Get rid of special characters like apostrophes
        token.gsub!(/\p{Lm}/, '')
        token.downcase!

        # Split words on punctuation and keep all pieces
        # that are at least 3 characters long as well as
        # the original word with all punctuation removed
        pieces = token.split(/[\p{P}\p{S}]/)
        pieces << token.gsub(/[\p{P}\p{S}]/, '') if pieces.count > 1
        pieces.each do |piece|
          dict[cat] << piece if piece.length >= 3 && piece =~ /\p{L}/
        end
      end
    end
  end

  puts "Writing dictionary to #{t.name} ..."
  File.open(t.name, 'w') do |f|
    dict.each do |cat, words|
      words = words.uniq.sort
      next if words.empty?
      puts " <- %6d #! #{cat}" % [words.size]

      f.puts "#! #{cat}"
      words.each { |word| f.puts word }
    end
  end

  puts "#{File.stat(t.name).size / 1024}k written"
end
