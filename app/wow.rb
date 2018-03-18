module Addons
  class Wow
    attr_accessor :addon_path, :collection

    def initialize(addon_path=nil)
      @addon_path = addon_path 
    end

    def fetch
      list_folders
      collection.sort { |x,y| x[:name] <=> y[:name] }.map { |ad|  puts "  #{ad[:name]}: #{ad[:version]}" }
      collection
    end

    #------
    private
    #------

      def list_folders
        @collection = []
        Dir.glob(addon_path + '/*').each do |fn|
          toc_fn = Dir.glob(fn + "/*.toc").first
          toc = Addons::TOC.new(File.open(toc_fn, "r").read, toc_fn.sub(addon_path+"/", ""))
          collection << toc.get_data
        end
      end
  end
end
