module Laravel
  # This class provides a means to create new applications based on the Laravel
  # framework.  Most of the methods used here have been defined in the
  # AppSupport module, which is being included as a mixin here.
  #
  class App
    # include the AppSupport module which has all the methods defined.
    include Laravel::Helpers
    include Laravel::AppSupport

    # these attributes must be available as: object.attribute
    attr_reader   :cache_folder, :laravel_repo, :app_path, :source, :cache, :options

    # This method initializes a new App object for us, on which we can apply
    # our changes.  Logically, this new App object represents an application
    # based on Laravel.
    #
    # ==== Parameters
    # +app_path+ :: The path to the Laravel based application. This can either
    # be a relative path to the current directory, or the absolute path. If
    # +app_path+ is not supplied, we assume current directory.
    #
    # +options+  :: A hash of options for this application. This hash can be
    # created manually, but more closely resembles the options choosen by the
    # user and forwarded by the Thor to us.
    #
    def initialize(app_path = nil, options = nil)
      app_path = Dir.pwd if not app_path or app_path.empty?
      @app_path = File.expand_path(app_path)

      @options = options

      @source = options[:source] if options
      @source = LaravelRepo if not @source or @source.empty?

      @cache = source_is_local? ? @source : cache_directory
    end

    # This method creates a new Laravel based application for us.  This method
    # is invoked by the 'new' task. It first checks if we can create the
    # application in the specified directory, then updates/downloads the local
    # cache for the given source, and then copies over the files from this
    # cache to the specified directory. Finally, it checks if we have a working
    # Laravel application at which point it either raises and error and cleans
    # up, or configures the application and installs tasks/bundles, as
    # requested.
    #
    def create
      # check if we are missing the required force
      required_force_is_missing?

      # apply some force, when we are boosted with one
      apply_force

      # download or update local cache
      download_or_update_local_cache

      # copy the framework files from the cache
      copy_over_cache_files

      # make necessary changes for the new app, if we were successful in download
      # otherwise, remove the downloaded source
      if has_laravel?
        say_success "Cloned Laravel repository."
        configure_from_options
        install_from_options
        say_success "Hurray! Your Laravel application has been created!"
      else
        say_failed "Downloaded source is not Laravel framework or a possible fork."
        show_info "Cleaning up.."
        clean_up
        raise InvalidSourceRepositoryError
      end
    end

    # This method installs the required tasks/bundles by the user.
    # It does so by invoking the 'from_options' method of the Installer class.
    def install_from_options
      install = Installer.new(@app_path, @options)
      install.from_options
    end

    # This method configures the application as required by the user.
    # It does so by invoking the 'from_options' method of the Configuration class.
    def configure_from_options
      config = Configuration.new(@app_path, @options)
      config.update_from_options
    end
  end
end
