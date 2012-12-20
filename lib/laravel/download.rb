module Laravel
  class Download
    # This method downloads the Laravel source files.
    #
    # When downloading from remote repositories, it checks to see if we have
    # previously used that repository (can be the official Laravel source or
    # forked one). If so, it updates the local copy of that repository and 
    # installs from it. Otherwise, it creates a local copy of the repository
    # so that future installs from that repository are instant.
    #
    # * *Args*    :
    #   - +path+ -> path to the destination
    # * *Returns* :
    #   - string containing error message, if any or is otherwise nil
    #
    def self.source(path, options)

      # make sure that the path does not already exists (no overwrites!)
      if File.exists?(path) and not options[:force]
        Laravel::say_error "directory already exists!"
      end

      # delete the existing files, if we are forced for this
      if options[:force]
        Laravel::say_info "Creating application forcefully!"
        FileUtils.rm_rf path
      end

      # create the requisite directory structure
      FileUtils.mkdir_p File.dirname(path)

      # download/update local repository as required
      local_repo_for_remote_path = options[:local] || self.local_repository(options)

      # copy the Laravel source to the required path
      FileUtils.cp_r local_repo_for_remote_path, path

      # make necessary changes for the new app, if we were successful in download
      # otherwise, remove the downloaded source
      if Laravel::has_laravel? path
        Laravel::say_success "Cloned Laravel repository."
        Laravel::Manage::update_index options[:index], path if options.has_key?("index")
        Laravel::say_success "Hurray! Your Laravel application has been created!"
      else
        Laravel::say_failed "Downloaded source is not Laravel framework or a possible fork."
        Laravel::say_info "Cleaning up.."
        FileUtils.rm_rf "#{path}"
        # delete_corrupted = Laravel::yes? "Should I delete the specified repository from local cache? (default: yes)"
        # if delete_corrupted
          # Laravel::say_info "Deleting local cache for this source!"
          # FileUtils.rm_rf "#{local_repo_for_remote_path}"
        # else
          # Laravel::say_info "Local cache for this source was not deleted!"
        # end
        FileUtils.rm_rf "#{local_repo_for_remote_path}"
        Laravel::say_error "Specified Laravel source is corrupt!"
      end
    end

    # Create or update local repository whenever a remote source is specified.
    #
    # * *Args*    :
    #   - +options+ -> arguments passed from other tasks, if any.
    # * *Returns* :
    #   - boolean depending on whether a download/update was done or not
    #
    def self.local_repository(options = {})
      # do not attempt download/update if user specifically wants to stay offline
      return if options.has_key?(:local)

      # prefer remote path, if specifically supplied by user
      # otherwise, default to the official repository
      remote_repo = options[:remote] || Laravel::OfficialRepository
      local_path_for_remote_repo = Laravel::crypted_path remote_repo

      # get the path to the git binary
      git = `which git`.strip

      # string which will suppress the output of commands in quiet mode
      # quiet = options[:quiet] ? "&>/dev/null" : "1>/dev/null"
      quiet = "&>/dev/null"

      # update or download the remote repository
      FileUtils.mkdir_p local_path_for_remote_repo
      # say_info "Created requisite directory structure."
      Dir.chdir local_path_for_remote_repo do
        if Laravel::local_repository_exists?(remote_repo)
          Laravel::say_info "Repository exists in local cache.."
          Laravel::say_info "Updating repository in local cache.."
          print `#{git} pull #{quiet}`
        else
          Laravel::say_info "Downloading repository to local cache.."
          print `#{git} clone #{remote_repo} . #{quiet}`
        end
      end

      local_path_for_remote_repo
    end
  end
end
