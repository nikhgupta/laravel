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
        return "directory already exists!"
      end

      # delete the existing files, if we are forced for this
      FileUtils.rm_rf path if options[:force]

      # create the requisite directory structure
      FileUtils.mkdir_p File.dirname(path)

      # download/update local repository as required
      local_repo_for_remote_path = options[:local] || Laravel::Download::local_repository(options)

      # copy the Laravel source to the required path
      FileUtils.cp_r local_repo_for_remote_path, path

      # remove the downloaded source if it is not a valid laravel source
      unless Laravel::has_laravel? path
        FileUtils.rm_rf "#{path}"
        FileUtils.rm_rf "#{local_repo_for_remote_path}"
        return "laravel source is corrupted!"
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
      quiet = options[:quiet] ? "&>/dev/null" : "1>/dev/null"

      # update or download the remote repository
      FileUtils.mkdir_p local_path_for_remote_repo
      Dir.chdir local_path_for_remote_repo do
        if Laravel::local_repository_exists?(remote_repo)
          puts "Updating repository in local cache.." unless options[:quiet]
          puts `#{git} pull #{quiet}`
        else
          puts "Downloading repository to local cache.." unless options[:quiet]
          puts `#{git} clone #{remote_repo} . #{quiet}`
        end
      end

      local_path_for_remote_repo
    end
  end
end
