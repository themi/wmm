require 'rubygems'
require 'mechanize'
require 'logger'
require 'yaml'

module Addons
  class Downloader
 
    attr_reader :agent, :download_path

    def initialize
      @download_path = Addons.config.download_path
      @agent = Mechanize.new { |a|
        if Addons.config.user_agent
          a.user_agent = Addons.config.user_agent 
        else
          a.user_agent_alias = 'Mac Safari' 
        end
        a.log = Logger.new "log/mechanize.log"
        a.pluggable_parser['application/zip'] = Mechanize::DirectorySaver.save_to(download_path)
        a.pluggable_parser["application/x-amz-json-1.0"] = Mechanize::DirectorySaver.save_to(download_path)
      }
    end

    def fetch(project_url, link_text)
      collection = []
      @agent.get(project_url) do |page|

        download = activate_download(page, project_url, link_text)
        list = extract_addons(File.join(download_path, download.filename), project_url)

        item = {
          project_url: project_url,
          link_text: link_text,
          file_name: download.filename,
          last_modified: download.header["last-modified"],
          addons: list
        }

        collection << item
      end

      collection
    end

    # -----
    private
    # -----
      def extract_addons(filename, project_url)
        zp = Addons::Zipper.new(filename, project_url)
        zp.toc_entries
      end

      def activate_download(page, project_url, link_text)
        link_text ||= "Download"
        btn = page.link_with(:text => /#{link_text}/)
        @agent.click(btn)
      end

  end
end
