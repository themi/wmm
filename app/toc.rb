require "toc/base"
require "toc/dbm"
require "toc/wqt"

module Addons
  module TOC

    def self.new(stream, filename, url="")
      if url =~ /deadlybossmods/
        DBM.new(stream, filename)
      elsif url =~ /curseforge.*world-quest-tracker/
        WQT.new(stream, filename)
      else
        Base.new(stream, filename)
      end
    end

  end
end
