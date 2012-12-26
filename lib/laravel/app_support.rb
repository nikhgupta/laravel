require 'digest/md5'

module Laravel
  # various methods that help with various classes defined for the Laravel module
  module AppSupport
    include Laravel::Helpers

    # Return the path to the local cache directory for a given Source
    #
    # ==== Return
    # +string+ :: Filepath to the local cache directory
    #
    def cache_directory
      File.join(Laravel::App::CacheFolder, make_md5(@source))
    end

    # Check whether the app directory is the current directory.
    # This is useful to know if we are creating the new application
    # in the current directory.
    #
    # ==== Return
    # +boolean+ :: True, if the app directory is the current directory.
    #
    def create_in_current_directory?
      is_current_directory?(@app_path)
    end

    # Check whether the app directory is empty?
    # This is useful to know if we are trying to create the new application
    # in an empty directory or not, so that we may know if we need to create
    # this application forcefully?
    #
    # ==== Return
    # +boolean+ :: True, if the app directory is an empty one.
    #
    def create_in_empty_directory?
      is_empty_directory?(@app_path)
    end

    # Check whether the specified source is a local directory or a URL?
    #
    # ==== Return
    # +boolean+ :: True, if the source is a local directory.
    #
    def source_is_local?
      File.directory?(@source)
    end

    # Merge the specified options with the options specified on the command line.
    #
    # ==== Parameters
    # +options+ :: hash of options passed at the command line
    #
    # ==== Return
    # +hash+ :: hash of merged options
    #
    def merge_options(options)
      @options.merge!(options)
    end

    # Return the path to the configuration file for the current application
    #
    # ==== Return
    # +string+ :: path to the configuration file
    #
    def config_file
      File.join(@app_path, %w[ application config application.php ])
    end

    # Return the path to a tasks file by its name
    #
    # ==== Parameters
    # +name+ :: string - name of the tasks file
    #
    # ==== Return
    # +string+ :: path to the tasks file
    #
    def tasks_file(name)
      File.expand_path(File.join(@app_path, %w[ application tasks ], name))
    end

    # check if laravel framework exists in the current application's directory
    # currently, this is performed by looking for the presence of 'artisan' file
    # and the 'laravel' subdirectory.
    #
    # ==== Return
    # +boolean+ :: true, if laravel framework exists
    #
    def has_laravel?
      laravel_exists_in_directory?(@app_path)
    end

    # check if the cache exists for the source specified by the current
    # application's directory this further makes sure that the cache really has
    # laravel framework as we would expect it to
    #
    # ==== Return
    # +boolean+ :: true, if the cache exists
    #
    def has_cache?
      laravel_exists_in_directory?(@cache)
    end

    # This method first checks if the given application path requires
    # the 'force' option, and then checks if the 'force' option is provided
    # by the user.
    #
    # Whether the path requires 'force' is determined as:
    #   -- it is not the current directory
    #   -- it is the current directory but is empty
    #
    # ==== Return
    # +error+ :: raises an error, if the 'force' parameter is required!!
    #
    def required_force_is_missing?
      # we need force if path exists and is not the current directory
      check_force   = (File.exists?(@app_path) and not create_in_current_directory?)
      # we need force if path is current directory but is not empty
      check_force ||= (create_in_current_directory? and not create_in_empty_directory?)
      # raise an error when we need to force and we have not been supplied with enforcements
      show_error "required force is missing! please, provide enforcements!" if check_force and not @options[:force]
    end

    # Depending on whether the 'force' parameter is provided, this method
    # removes all the files in the directory specified by the application path,
    # if the directory exists.  Further, if the directory doesn't exist, it
    # tries to create the directory specified by the application path.
    #
    def apply_force
      show_info "Creating application forcefully!" if @options[:force]
      FileUtils.rm_rf("#{@app_path}/.", :secure => true) if File.exists?(@app_path) and @options[:force]
      FileUtils.mkdir_p @app_path
    end

    # This method downloads or updates the local cache for the current source.
    #
    # If the source is a directory on this machine, it will simply not do
    # anything since that can interfere with an offline installation, and the
    # user must update the source manually in this case.
    #
    # Otherwise, it uses git to update or download the source as required and
    # caches it locally.
    #
    def download_or_update_local_cache
      return if source_is_local?
      show_error "git is required!" if `which git`.empty?
      FileUtils.mkdir_p @cache
      Dir.chdir(@cache) do
        if has_cache?
          show_info "Repository exists in local cache.."
          show_info "Updating local cache.."
          `git pull &>/dev/null`
        else
          show_info "Downloading repository to local cache.."
          `git clone #{@source} . &>/dev/null`
        end
      end
    end

    # This method copies the files from the local cache to the directory of the
    # application.
    #
    def copy_over_cache_files
      FileUtils.cp_r "#{@cache}/.", @app_path
    end

    # This method updates the permissions on the storage/ directory inside
    # the newly created application. This method does not have a separate exposed
    # call from the CLI. This can be skipped by passing '--no-perms' for the 'new'
    # command.
    #
    def update_permissions_on_storage
      if @options[:perms]
        response = system("chmod -R o+w #{File.join(@app_path, 'storage')}")
        if response
          say_success "Updated permissions on storage/ directory."
        else
          say_failed "Could not update permissions on storage/ directory."
        end
      end
    end

    # Once, we are done with the intallation, and an error occurs, this method handles
    # the clean_up routine by removing the application directory we created, as well as
    # the local cache for the source, that may exist.
    #
    # Keeping the local cache does not make sense, since we anyways can not create
    # applications based on these 'corrupt' repositories.
    def clean_up
      FileUtils.rm_rf "#{@app_path}" unless current_directory?
      FileUtils.rm_rf "#{@cache}"
    end
  end
end
