module Laravel
  # a means to test the gem
  class AppTests
    attr_reader :app, :app_dir, :repo, :aruba

    # create a new object that handles the tests for us
    #
    # ==== Parameters
    # +dir+  :: directory of the application - can be relative path or absolute path.
    # +repo+ :: repository URL/directory for source
    #
    def initialize(dir = nil, repo = nil)
      @repo    = repo
      @aruba   = File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. tmp aruba]))

      # Store absolute path to the directory
      @app_dir = dir || Dir.pwd
      convert_to_relative_path

      options = {
        :force  => false, :quiet  => false,
        :perms  => true,  :source => get_source_url
      }

      # create a new Laravel App instance for given options
      @app = Laravel::App.new(@app_dir, options)
    end

    # get the relative path of a directory relative to the temporary path aruba creates
    #
    # ==== Parameters
    # +relative_to+ :: Path to use as base directory, when converting to relative path.
    #                  By default, it is the path to the aruba tmp directory
    #
    def convert_to_relative_path(relative_to = nil)
      relative_to = @aruba unless relative_to
      @app_dir = File.expand_path(@app_dir, relative_to)
    end

    # get the url to a repository by a given alias/name
    #
    # ==== Return
    # +string+ :: URL for the repository
    #
    def get_source_url
      case @repo
      when nil, "", "official", "default" then Laravel::App::LaravelRepo
      when "pastes"  then "http://github.com/laravel/pastes"
      when "non_laravel" then "http://github.com/github/gitignore"
      else @repo
      end
    end

    # checks if the configuration file contains a particular string
    #
    # ==== Parameters
    # +search+ :: the search term/regex pattern to look for
    #
    # ==== Return
    # +boolean+:: true, if the search term was found in the configuration file.
    #
    def validate_configuration(search)
      raise_error? File.readlines(@app.config_file).grep(Regexp.new search).any?
    end

    # raises an error based on a condition and negation
    # if negation is not supplied, simply raises an error if condition is not true
    #
    # ==== Parameters
    # +condition+ :: a condition to check against - if +negate+ is not provided,
    #                this condition raises an error if it evaluates to false.
    # +negate+ :: negate the default behaviour
    def raise_error?(condition, negate = nil)
      raise RSpec::Expectations::ExpectationNotMetError if condition == !negate.nil?
    end
  end
end

World(Laravel)
