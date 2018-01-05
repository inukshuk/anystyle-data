module AnyStyle
  module Data
    ROOT = File.expand_path('..', __FILE__).untaint

    def self.setup
      Dictionary.defaults[:source] = File.join(ROOT, 'dict.txt.gz')
      Dictionary::GDBM.defaults[:path] = File.join(ROOT, 'dict.db')
      Dictionary::LDBM.defaults[:path] = ROOT
    end
  end
end
