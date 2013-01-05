module Laravel
  # This class handles the configuration aspects of a Laravel based
  # application.  This allows us to read and update settings in
  # ./application/config/application.php Furthermore, it allows us to read and
  # update various options, at one go.
  class Configuration
    # include Helpers and AppSupport modules that have the helper methods defined
    include Laravel::Helpers
    include Laravel::AppSupport

    attr_reader :path, :config

    # Create a new Configuration class, which helps us to configure
    # an existing Laravel application.
    #
    # ==== Parameters
    # +path+ :: Path to an existing Laravel application, which can
    # either be relative or an absolute path. If path is not supplied,
    # we assume current directory.
    #
    # +config+ :: It can be a comma-separated string or an array or a hash
    # of `key:value` pairs. When creating a new app, +config+ is passed as a
    # comma-separated string.
    #
    #   Examples:
    #     index:"",key,profiler:on,url:http://laravel.com
    #     index,key:some_secret_key,ssl:enabled
    #
    def initialize(path = nil, config = nil)
      self.path = path

      # try to do anything only if this is a Laravel application
      # otherwise, raise an error
      raise LaravelNotFoundError unless has_laravel?

      # set the desired configuration options
      self.config = config

    end

    # Expand the supplied path for the application.
    #
    # ==== Parameters
    # +path+ :: Path to an existing Laravel application, which can
    # either be relative or an absolute path. If path is not supplied,
    # we assume current directory.
    #
    def path=(path = nil)
      path  = Dir.pwd if not path or path.strip.empty?
      @path = File.expand_path(path)
    end

    # Create a configuration hash from the supplied input format
    #
    # ==== Parameters
    # +config+ :: It can be a comma-separated string or an array or a hash
    # of `key:value` pairs. When creating a new app, +config+ is passed as a
    # comma-separated string.
    #
    #   Examples:
    #     index:"",key,profiler:on,url:http://laravel.com
    #     index,key:some_secret_key,ssl:enabled
    #
    def config=(config = {})
      @config = config.is_a?(Hash) ? config : {}
      config  = config.split(",") if config.is_a?(String)
      if config.is_a?(Array)
        config.each do |c|
          c = c.split(":", 2)
          @config[c[0]] = c[1]
        end
      end
    end

    # Update a configuration setting in the configuration file
    #
    # ==== Parameters
    # +config+ :: one of the configuration settings as provided in the
    # configuration file for the application
    #
    # +value+ :: the new value for the supplied +config+ setting. Note that,
    # for configuration settings that take a boolean value, you can pass values
    # like 'true', 'enabled', 'active', 'on', 1 etc. to signify truth.
    #
    def update(config, value)
      return if unsupported? config
      value   = process_input(config, value)
      updated = __update_configuration(config, value)
      value   = "__empty_string__" if is_blank?(value)
      if updated
        say_success "Updated configuration: #{config} => #{value}"
      else
        say_failed "Could not update configuration: #{config}"
      end
    end

    # Reads a configuration setting from the configuration file
    #
    # ==== Parameters
    # +config+ :: one of the configuration settings as provided in the
    # configuration file for the application
    #
    def read(config)
      return if unsupported? config
      value = __read_configuration(config)
      value = "__empty_string__" if is_blank?(value)
      if value
        say_success "Configuration: #{config} => #{value}"
      else
        say_failed "Could not read configuration: #{config}"
      end
    end

    # update the configuration settings by looking at the options
    # that the user has provided when running the 'new' task.
    #
    def from_options
      # don't do anything, unless options were provided
      return if not @config or @config.empty?
      @config.each { |key, value| update(key, value) }
    end

    # Process input when we are configuring the Application Key.
    # By default, generates a random 32 char string, but if a string is
    # passed as +value+, returns it without further processing.
    #
    # ==== Parameters
    # +value+:: optional string, that if provided will be used as the new key
    #            instead of generating a random one.
    #
    # ==== Returns
    # String:: the new key for the application
    #
    def process_input_for_key(value = nil)
      return value unless is_blank?(value)
      make_md5
    end

    # Process input when we are configuring the Profiler setting.
    # Simply checks if the supplied +value+ corresponds to a 'truthy' value
    # and returns it.
    #
    # ==== Parameters
    # +value+ :: a string that signifies either the truth or false. It can take
    # multiple values like enabled, active, on, etc. to signify truth.
    #
    # ==== Return
    # +boolean+ :: the new value for the Profiler setting
    #
    def process_input_for_profiler(value)
      __convert_action_to_boolean value
    end

    # Process input when we are configuring the SSL setting.
    # Simply checks if the supplied +value+ corresponds to a 'truthy' value
    # and returns it.
    #
    # ==== Parameters
    # +value+ :: a string that signifies either the truth or false. It can take
    # multiple values like enabled, active, on, etc. to signify truth.
    #
    # ==== Return
    # +boolean+ :: the new value for the SSL setting
    #
    def process_input_for_ssl(value)
      __convert_action_to_boolean value
    end

    private

    # Check if the supplied +config+ setting is supported, at the moment?
    # Currently, this class does not support configuration settings that take
    # a PHP array as their value.
    #
    # ==== Parameters
    # +config+ :: the configuration setting to test
    #
    # ==== Return
    # +boolean+ :: true, if the configuration setting is unsupported
    #
    def unsupported?(config)
      unsupported_configs = [ "languages", "aliases" ]
      unsupported = unsupported_configs.include? config
      say_failed "Configuration: #{config} is not supported!" if unsupported
      unsupported
    end

    # Process the input +value+ for the given +config+ setting.
    # The method checks to see if a method exists by the name:
    # 'process_input_for_{config}' and if so, passes the +value+
    # to that method for processing, and returns the new value.
    #
    # ==== Parameters
    # +config+ :: the configuration setting that needs the update
    #
    # +value+ :: the input value that was supplied when running the task
    #
    # ==== Return
    # +mixed+ :: the new value after processing the given input
    def process_input(config, value)
      name = "process_input_for_#{config}"
      if Configuration.method_defined? name
        value = method(name).call(value)
      end
      value
    end

    # This method transforms the given input into true or false
    # so that the user can say things like:
    #
    #     laravel config update ssl enabled
    #     laravel config update profiler active
    #
    # ==== Parameters
    # +value+ :: the input value that was supplied when running the task
    #
    # ==== Return
    # +boolean+ :: the processed input value
    #
    def __convert_action_to_boolean(value = nil)
      on  = [ true, "true", "active", "activated",
              "enable", "enabled", "yes", "on", "1", 1 ]
      on.include?(value) ? true : false
    end

    # handle the config update routine.
    # this method first makes the required update in the configuration file,
    # then it checks whether the update was successful? If not, the method
    # reverts to the old configuration and returns whether we were successful
    # in making the update or not.
    #
    # ==== Parameters
    # +key+:: the configuration setting which will be updated
    # +new_value:: the new value for the configuration defined by +key+
    #
    # ==== Returns
    # Boolean:: true if the update was successful.
    #
    def __update_configuration(key, new_value)
      conf = config_file
      replace = new_value.is_a?(String) ? "'#{new_value}'" : new_value
      check   = new_value.is_a?(String) ? Regexp.escape(replace) : replace

      # make the required substitution in the configuration file
      text = File.read conf
      updated_text = text.gsub(/'#{key}' => .*,/, "'#{key}' => #{replace},")
      File.open(conf, "w") {|file| file.puts updated_text}

      # check to ensure we were able to update configuration
      updated = File.readlines(conf).grep(/'#{key}' => #{check},/).any?

      # revert if we could not update the configuration
      File.open(conf, "w") {|file| file.puts text} unless updated

      # response with a success or failure
      updated
    end

    # handle the config read routine.
    #
    # ==== Parameters
    # +key+ :: the configuration setting which needs to be read
    #
    # ==== Return
    # +mixed+ :: the current value for the supplied configuration setting
    #
    def __read_configuration(key)
      conf = config_file

      # make the required substitution in the configuration file
      text  = File.read conf
      match = text.match(/'#{key}' => (.*),/)
      match ? match[1] : nil
    end
  end
end
