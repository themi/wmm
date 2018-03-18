module Addons
  module TOC
    class DBM < Base
      attr_reader :base_filename

      def get_data(base_filename)
        @base_filename = base_filename
        super
      end

      # -----
      private 
      # -----

        def get_version
          result = base_filename.match /.*(\d{1,}.\d{1,}.\d{1,}-r\d{1,})-.*/
          result.nil? ? "" : result[1]
        end

    end
  end
end

