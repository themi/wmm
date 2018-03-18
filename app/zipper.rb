require "zip"

module Addons
  class Zipper
    attr_accessor :archive, :url
    attr_reader :collection, :wow_addon_location

    def initialize(archive, url="")
      @archive = archive
      @url = url
      @collection = []
      @wow_addon_location = Addons.config.wow_addon_location
    end

    def toc_entries
      Zip::File.open(archive) do |zip_file|
        zip_file.each do |entry|
          if root_folder?(entry.name) && toc?(entry.name)
            collection << get_data(entry)
          end
        end
      end
      collection
    end

    def extract
      cmd = ["unzip", archive, "-d", "'#{wow_addon_location}'"].join(" ")
      `#{cmd}`
    end

    # -----
    private
    # -----

      def root_folder?(path)
        path.split("/").length == 2 
      end

      def toc?(path)
        !path.match(/.toc/).nil?
      end

      def get_data(entry)
        toc = Addons::TOC.new(entry.get_input_stream.read, entry.name, url)
        toc.get_data(archive)
      end

  end
end
