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


task :compile => [:clean, 'lib/anystyle/data/dict.txt.gz'] do

end

require 'yaml'
DIC_DEF_FILE = 'res/dictionary.yaml'
dict_def = YAML.load(File.read(DIC_DEF_FILE))
dict_def.each do | cat, files |
  dict_def[cat] = files.map { | f | "res/dict-src/#{f}.txt" }
end

file 'lib/anystyle/data/dict.txt.gz' =>
     [ DIC_DEF_FILE, *dict_def.values.flatten ] do | dic_file |
  entries = {}
  comments = {}
  dict_def.each do | cat, dfiles |
    entries[cat] ||= {}
    comments[cat] ||= []
    dfiles.each do | dfile |
      multitokens = false
      File.foreach(dfile, encoding: "UTF-8") do | line |
        case line
        when /^#\+\s*MULTITOKENS/i
          multitokens = true
        when /^##/
          comments[cat] << line
        when /^#/ # Discard
        else # 
          # Canonical - lower case, no punctuation
          line = line.gsub(/(?:\p{P}|\p{S})/, "").downcase
          if multitokens # More than one per line
            tokens = line.split(/\s+/).grep_v(/^\d+$/)
          else # Only first per line
            tokens = [ line.split(/\s+(\d+\.\d+)\s*$/)[0] ] 
          end
          tokens.each { | tok | entries[cat][tok] = true }
        end
      end
    end
  end
  
  require 'zlib'
  Zlib::GzipWriter.open(dic_file.to_s) do | dic_zip |
    entries.each do | cat, items |
      dic_zip.puts "## @#{cat}@"
      comments[cat].each { | c | dic_zip.puts c }
      items.keys.sort.each { | i | dic_zip.puts i }
    end
  end
end
