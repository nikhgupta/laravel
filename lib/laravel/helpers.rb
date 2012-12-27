module Laravel
  module Helpers

    # the path to the folder where the sources will be locally cached.
    CacheFolder = File.join(ENV['HOME'], %w[ .laravel repos ])

    # the official Laravel repository URL which is also the default source for us.
    LaravelRepo = "http://github.com/laravel/laravel"

    # the path to the setting.yml file for this gem
    GemSettings = File.join(File.dirname(__FILE__), "settings.yml")

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

    # Check whether the given directory is the current directory.
    #
    # ==== Return
    # +boolean+ :: True, if the app directory is the current directory.
    #
    def is_current_directory?(dir = nil)
      dir ||= Dir.pwd
      dir = File.expand_path(dir)
      File.directory?(dir) and (dir == File.expand_path(Dir.pwd))
    end

    # Check whether the given directory is empty?
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
    #             sure that the +source+ is a git repository when +path+ is a directory,
    #             and that the +source+ is an online file when +path+ is a file.
    # +source+ :: Source URL/directory from where the content of the resource will be
    #             downloaded. Please, read information about +path+
    #
    # ==== Return
    # +boolean+ :: true, if the resource was downloaded successfully.
    #
    def download_resource(path, source, using)
      raise RequiredLibraryMissingError, "curl" if using == "curl" and `which curl`.empty? and `which wget`.empty?
      raise RequiredLibraryMissingError, "git" if using == "git"

      using = "wget" if using == "curl" and `which curl`.empty? and not `which wget`.empty?
      case using
      when "git"  then system("git clone -q #{source} #{path}")
      when "curl" then system("curl -s #{source} > #{path}")
      when "wget" then system("wget #{source} -O #{path}")
      else raise RequiredLibraryMissingError
      end
    end

    # check if laravel framework exists in a specified directory
    #
    # ==== Parameters
    # +directory+ :: directory to check for the existance of laravel framework
    #                this can be the relative path to the current app directory
    #                or the absolute path of the directory.
    # +relative_to+ :: if the +directory+ is a relative path, we can define the
    #                  base directory here.
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

    # read the yaml configuration from a file
    #
    def read_yaml(file)
      raise FileNotFoundError, file unless File.exists?(file)
      data = YAML.load(File.open(file))
      # adjust the 'config' hash by making substitutions
      data["config"].each do |setting, matrix|
        data["config"].delete(setting) if matrix.has_key?("supported") and not matrix["supported"]
        data["config"][setting]["default"] = matrix["factory"] if matrix["default"] == "__factory__"
      end
      data
    end

    # write the configuration to a yaml file
    #
    def write_yaml(data, file)
      raise FileNotFoundError, file unless File.exists?(file)
      File.open(file, "w") {|f| f.write(data.to_yaml) }
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

  end
end
