module Addons
  module TOC
    class Base
      attr_accessor :stream, :filename

      def initialize(stream, filename)
        @stream   = stream
        @filename = filename
      end

      def get_data(*)
        { 
          name: get_name,
          version: get_version,
          interface: get_interface
        }
      end

      # -----
      private 
      # -----
        def get_datum(datum)
          result = /#{datum}: ?(.*)$/.match(stream)
          (result.nil? ? "" : result[1]).strip
        end

        def get_name
          filename.split("/").first
        end

        def get_version
          get_datum("Version")
        end

        def get_interface
          get_datum("Interface")
        end
    end
  end
end
