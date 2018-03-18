require 'fileutils'
require 'yaml'

require "downloader"
require "wow"
require "zipper"
require "toc"
require "manager"
require "config"

Addons.configure do |c|
  c.user_agent         = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.2 Safari/605.1.15"
  c.download_path      = "downloads"
  c.library_path       = "library"
  c.wow_addon_location = "/Applications/World\ of\ Warcraft/interface/addons"
end
