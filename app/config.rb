require 'ostruct'
 
module Addons
 
  class Config < OpenStruct
  end
 
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end
 
end
