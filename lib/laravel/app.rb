module Laravel
  # This class provides a means to create new applications based on the Laravel
  # framework.  Most of the methods used here have been defined in the
  # AppSupport module, which is being included as a mixin here.
  #
  class App
    # include the Helpers and AppSupport modules which have all the helper methods defined.
    include Laravel::Helpers
    include Laravel::AppSupport

    # these attributes must be available as: object.attribute
    attr_reader   :path, :source, :cache, :options

    # This method initializes a new App object for us, on which we can apply
    # our changes.  Logically, this new App object represents an application
    # based on Laravel.
    #
    # ==== Parameters
    # +path+ :: The path to the Laravel based application. This can either
    # be a relative path to the current directory, or the absolute path. If
    # +path+ is not supplied, we assume current directory.
    #
    # +options+  :: A hash of options for this application. This hash can be
    # created manually, but more closely resembles the options choosen by the
    # user and forwarded by the Thor to us.
    #
    def initialize(path = nil, options = nil)
      self.path    = path
      self.options = options
      self.source  = options[:source] || nil
    end

    # Expands the supplied +path+ for the application so that we have an absolute
    # directory path to work with.
    #
    # ==== Parameters
    # +path+ :: The path to the laravel based application. If path is not supplied,
    # we assume the current directory.
    #
    def path=(path="")
      path = Dir.pwd if not path or path.empty?
      @path = File.expand_path(path)
    end

    # Merge the given options with the already existing options.
    #
    # ==== Parameters
    # +options+ :: a hash of options to merge
    #
    def options=(options={})
      @options = @options ? @options.merge(options) : options
    end

    # Set the source for this application, and implicitely, set the directory
    # path for the local cache for this source.
    #
    # ==== Parameters
    # +source+ :: the source url or directory path
    #
    def source=(source=nil)
      # source must default to Official Laravel Repository if none is provided
      @source = options[:source] if options
      @source = LaravelRepo if not @source or @source.empty?

      # if the specified source is a remote repository, create a cache
      # directory otherwise, use the source as the cache
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

      # make necessary changes for the new app, if we were successful in
      # download otherwise, remove the downloaded source
      if has_laravel?
        say_success "Cloned Laravel repository."

        # update permissions on storage/ directory (this is the default)
        update_permissions_on_storage if @options[:perms]

        # configure this new application, as required
        configure_from_options

        # download goodies for this new application, as specified
        install_from_options

        say_success "Hurray! Your Laravel application has been created!"
      else
        say_failed "Downloaded source is not Laravel framework or its fork."
        show_info "Cleaning up.."
        # remove all directories that we created, as well as the cache.
        clean_up
        # raise an error since we failed.. :(
        raise LaravelError, "Source for downloading repository is corrupt!"
      end
    end

    # This method installs the required tasks/bundles by the user.
    # It does so by invoking the 'from_options' method of the Installer class.
    #
    # FIXME: This is bad code since the Super class knows about its Children
    def install_from_options
      if @options[:install]
        installer = Installer.new(@path, @options[:install])
        installer.from_options
      end
    end

    # This method configures the application as required by the user.
    # It does so by invoking the 'from_options' method of the Configuration class.
    #
    def configure_from_options
      if @options[:config]
        config = Configuration.new(@path, @options[:config])
        config.from_options
      end
    end
  end
end
