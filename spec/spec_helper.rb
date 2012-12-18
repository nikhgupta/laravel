require 'laravel'

module Laravel
  class Tests
    TestAppDirectory = File.join( File.dirname(__FILE__), %w[ .. __tests ] )

    def self.app_path(app_name)
      File.join(Laravel::Tests::TestAppDirectory, app_name)
    end

    def self.app_downloads_nicely?(app_name, options = {})
      options[:quiet] = true
      app_path   = Laravel::Tests::app_path app_name
      error      = Laravel::Download::source(app_path, options)
      error ? nil : app_path
    end

    def self.download_was_performed?(app_path)
      app_path && File.directory?(app_path)
    end

    def self.cleanup(app_name, repo = "")
      FileUtils.rm_rf Laravel::crypted_path(repo) if repo
      FileUtils.rm_rf Laravel::Tests::app_path(app_name) if app_name
    end
  end
end

# include Laravel
RSpec.configure do |c|
  c.fail_fast = true
  c.color = true
  c.formatter = :documentation
end
