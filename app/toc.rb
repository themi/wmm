require "toc/base"
require "toc/dbm"

module Addons
  module TOC

    def self.new(stream, filename, url="")
      if url =~ /deadlybossmods/
        DBM.new(stream, filename)
      else
        Base.new(stream, filename)
      end
    end

  end
end
