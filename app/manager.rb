module Addons
  class Manager
    attr_reader :download_list, :wow_folder, :index_file
    attr_accessor :download_path, :library_path, :verbose, :wow_addon_location, :update_list

    def initialize(verbose=true)
      @verbose            = verbose
      @download_path      = Addons.config.download_path
      @library_path       = Addons.config.library_path
      @wow_addon_location = Addons.config.wow_addon_location
      @index_file         = "library.yml"
      @update_list = nil
    end

    def refresh_downloads
      if verbose
        puts "Downloading listed wow addons:"
        STDOUT.flush
      end

      set_download_location

      @download_list = refresh_library(load_download_list)

      save_download_library

      if verbose
        puts "\nReading wow addon folder:"
        STDOUT.flush
      end
      @wow_folder = read_wow_folder
    end

    def compare_versions
      if verbose
        puts "\nComparing wow addon versions:"
        STDOUT.flush
      end
      wow_folder.each do |addon|
        check_download(addon)
        update_list.map {|dl| puts "  #{dl[:file_name]}"}
      end
    end

    def update_all
      # return if !wow_folder? || !update?

      if verbose
        puts "\nUpdating wow addons:"
        STDOUT.flush
      end

      update_list.each do |download|
        puts "  #{download[:file_name]}"
        update_addon(download)
      end

    end

    def update_addon(item)
      FileUtils.rm_rf("addon_backup")

      item[:addons].each do |addon|
        folder = File.join(wow_addon_location, addon[:name])
        if File.exist?(folder)
          FileUtils.mv(folder, "addon_backup")
        end
      end

      Addons::Zipper.new(File.join(library_path,item[:file_name])).extract
    end


    # -----
    private
    # -----
      def wow_folder?
        !(@wow_folder.nil? || wow_folder.empty?)
      end

      def update?
        !(update_list.nil? || update_list.empty?)
      end

      def update_list
        @update_list ||= download_list.select { |w| !!w[:update] }
      end

      def check_download(target_addon)
        download_list.each do |download| 
          item = download[:addons].select {|search_addon| search_addon[:name] == target_addon[:name]}.first
          if item
            download[:update] = (item[:version] == target_addon[:version]) || !!download[:update]
            break
          end
        end
      end

      def load_download_list
        YAML.load_file(index_file)[:downloads]
      end

      def refresh_library(previous_list)
        dl = Addons::Downloader.new
        current_list = []

        previous_list.each do |project|
          item = dl.fetch(project[:project_url], project[:link_text])
          if verbose
            item.first[:addons].map {|i| puts "  #{i[:name]}" } 
            STDOUT.flush
          end 
          current_list << item
        end

        current_list.flatten
      end

      def set_download_location
        FileUtils.mkdir_p(download_path)
      end

      def save_download_library
        FileUtils.rm_rf("archive")
        FileUtils.mv(library_path, "archive")
        FileUtils.mv(download_path, library_path)
        File.open(index_file, "w") {|f| f.write({downloads: download_list}.to_yaml) }
      end

      def read_wow_folder
        wow_addons = Addons::Wow.new(wow_addon_location).fetch
        wow_addons.flatten
      end

  end
end
