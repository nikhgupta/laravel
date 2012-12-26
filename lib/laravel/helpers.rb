module Laravel
  module Helpers

    # convert a string to MD5 hash - useful to generate quick random strings.
    #
    # ==== Parameters
    # +string+ :: optional, the input string to be hashed
    #          :: a random string will be used for hashing, if this string is not provided
    #
    # ==== Return
    # +string+ :: a 32-character long MD5'ed string
    #
    def make_md5(string = nil)
      string ||= (0...32).map{ ('a'..'z').to_a[rand(26)] }.join
      (Digest::MD5.new << string).to_s
    end

    # Check whether the app directory is the current directory.
    # This is useful to know if we are creating the new application
    # in the current directory.
    #
    # ==== Return
    # +boolean+ :: True, if the app directory is the current directory.
    #
    def is_current_directory?(dir = nil)
      dir ||= Dir.pwd
      dir = File.expand_path(dir)
      File.directory?(dir) and (dir == File.expand_path(Dir.pwd))
    end

    # Check whether the app directory is empty?
    # This is useful to know if we are trying to create the new application
    # in an empty directory or not, so that we may know if we need to create
    # this application forcefully?
    #
    # ==== Return
    # +boolean+ :: True, if the app directory is an empty one.
    #
    def is_empty_directory?(dir = nil)
      dir ||= Dir.pwd
      dir = File.expand_path(dir)
      File.directory?(dir) and (Dir.entries(dir).size == 2)
    end

    # Download a given resource at a particular path
    #
    # ==== Parameters
    # +path+   :: Path where the downloaded content will be saved.
    #             This can either be the path to a single file or a directory.
    #             If this is a directory, git will be used to download the source,
    #             otherwise, curl will be used for the same. Therefore, please, make
    #             sure that the source is a git repository when +path+ is a directory,
    #             and that the source is an online file when +path+ is a file.
    # +source+ :: Source URL/directory from where the content of the resource will be
    #             downloaded. Please, read information about +path+
    #
    # ==== Return
    # +boolean+ :: true, if the resource was downloaded successfully.
    #
    def download_resource(path, source, using)
      using = "wget" if using == "curl" and `which curl`.empty? and not `which wget`.empty?
      case using
      when "git"  then system("git clone -q #{source} #{path}")
      when "curl" then system("curl -s #{source} > #{path}")
      when "wget" then system("wget #{source} -O #{path}")
      else false
      end
    end

    # check if laravel framework exists in a specified directory
    # this method is in turn called by the instance methods: 'has_cache?'
    # and the 'has_laravel?'
    #
    # ==== Parameters
    # +directory+ :: directory to check for the existance of laravel framework
    #                this can be the relative path to the current app directory
    #                or the absolute path of the directory.
    #
    # ==== Return
    # +boolean+ :: true, if laravel exists in the given directory
    #
    def laravel_exists_in_directory?(directory = nil, relative_to = nil)
      return false unless directory
      directory = File.expand_path(directory, relative_to)
      return false unless File.exists? File.join(directory, "artisan")
      return false unless File.directory? File.join(directory, "laravel")
      true
    end

    # This method, simply, imitates the 'say' method that the Thor gem provides us.
    # I preferred to use this method, since it gives us a very nice UI at the CLI :)
    #
    def say(status, message = "", log_status = true)
      shell = Thor::Shell::Color.new
      log_status = false if @options and @options[:quiet]
      shell.say_status(status, message, log_status)
    end

    # Show some information to the user in Cyan.
    def show_info(message)
      say "Information", message, :cyan
    end

    # Show a success message to the user in Green.
    def say_success(message)
      say "Success", message, :green
    end

    # Show a failed message to the user in Yellow.
    def say_failed(message)
      say "Failed!!", message, :yellow
    end

    # Show an error the user in Red, and exit the script, since this is an error!
    def show_error(message)
      say "!!ERROR!!", message, :red
      exit
    end
  end
end
