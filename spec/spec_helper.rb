require 'laravel'

module Laravel
  class Tests
    TestAppDirectory = File.join( File.dirname(__FILE__), %w[ .. __tests ] )

    # get path to the test application
    def self.app_path(app_name)
      File.join(Laravel::Tests::TestAppDirectory, app_name)
    end

    # perform an application download using Laravel::Download
    def self.app_downloads_nicely?(options = {}, app_name = "")
      app_name ||= (('a'..'z').to_a+('A'..'Z').to_a).shuffle[0,32].join
      options[:quiet] = true
      app_path   = Laravel::Tests::app_path app_name
      error      = Laravel::Download::source(app_path, options)
      error ? nil : app_path
    end

    # check if the download was successful
    def self.download_was_performed?(app_path)
      app_path && File.directory?(app_path)
    end

    # check if the application was created?
    def self.app_was_created?(app_path)
      return false unless Laravel::Tests::download_was_performed?(app_path)
      return false unless Laravel::has_laravel?(app_path)
      true
    end

    # cleanup before and after our tests
    def self.cleanup(repo = "")
      FileUtils.rm_rf Laravel::Tests::TestAppDirectory
      FileUtils.rm_rf Laravel::crypted_path(repo) if repo
    end
  end
end
