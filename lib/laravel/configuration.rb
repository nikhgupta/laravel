module Laravel
  # This class handles the configuration aspects of a Laravel based
  # application.  This allows us to read and update settings in
  # ./application/config/application.php Furthermore, it allows us to read and
  # update various options, at one go.
  class Configuration

    include Laravel::Helpers
    include Laravel::AppSupport

    attr_reader :path, :config

    def initialize(path = nil, config = nil)
      self.path = path
      self.config = config
    end

    def path=(path = nil)
      path  = Dir.pwd if not path or path.strip.empty?
      @path = File.expand_path(path)
    end

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

    # This method creates dynamic read/update methods exposed by this class.
    # For this to work, the exposed functions have a definite naming
    # convention: {action}_{setting}, where {action} can be either 'read' or
    # 'update', and {setting} can be one of the settings found in the
    # configuration file.
    #
    # For example: calling: update_index("home.php") will update the 'index'
    # setting to use 'home.php' also, calling: update_key() will update the
    # 'key' to a 32-char long string.
    #
    # The second example above automatically generates a 32-char string by
    # calling 'do_update_key' method implicitely, which returns this string.
    #
    # The 'do_{method}' methods must be defined in this class, which return the
    # manipulated input from callee.
    #
    def method_missing(name, *args)
      # understand what the callee is requesting..
      dissect = name.to_s.split("_", 2)
      action  = dissect[0]
      setting = dissect[1]

      if ["languages", "aliases"].include?(setting)
        say_failed "Configuration settings: 'languages' and 'aliases' are not supported!"
        return
      end

      # lets manipulate the input value if a 'do_{method}' exists
      if Configuration.method_defined?("do_#{name}".to_sym)
        new_value = method("do_#{name}").call(args[0])
      end
      # otherwise, use the passed value without any manipulations
      new_value = args[0] if is_blank?(new_value)

      # handle the {action} part of the method
      # performs a read/update on the Configuration setting.
      response = case action
                 when "read" then __read_config(setting)
                 when "update" then __update_config(setting, new_value)
                 end

      # let the user know when we set the value to an empty string
      new_value = "__empty_string__" if is_blank?(new_value)

      # Let the user know that we have performed an action
      if response and (action != "read")
        say_success "#{action.capitalize}d configuration: #{setting} => #{new_value}"
      elsif !response.nil? and (action == "read")
        say_success "Configuration: #{setting} => #{response}"
      else
        say_failed "Could not #{action} configuration: #{setting}!"
      end
    end

    # lets generate the random string required by the 'update_key' method
    #
    # ==== Parameters
    # +value+:: optional string, that if provided will be used as the new key
    #            instead of generating a random one.
    #
    # ==== Returns
    # String:: the new key for the application
    def do_update_key(value = nil)
      return value unless is_blank?(value)
      make_md5
    end

    def do_update_profiler(value)
      __convert_action_to_boolean value
    end

    def do_update_ssl(value)
      __convert_action_to_boolean value
    end

    # update the configuration settings by looking at the options
    # that the user has provided when running the 'new' task.
    #
    def from_options
      # don't do anything, unless options were provided
      return if not @config or @config.empty?
      @config.each do |key, value|
        send("update_#{key}", value)
      end
    end

    private

    def __convert_action_to_boolean(value = nil)
      on  = [ true, "true", "active", "activated",
              "enable", "enabled", "yes", "on", "1", 1 ]
      on.include?(value) ? true : false
    end

    # handle the config update routine.
    # this method first checks to see if the current app is a Laravel
    # based application, and then performs the update for this setting.
    # Finally, it checks whether the update was successful and returns it.
    #
    # ==== Parameters
    # +key+:: the configuration setting which will be updated
    # +new_value:: the new value for the configuration defined by +key+
    #
    # ==== Returns
    # Boolean:: true if the update was successful.
    #
    def __update_config(key, new_value)
      # try to change configuration only if this is a Laravel application
      # otherwise, raise an error
      raise LaravelNotFoundError unless has_laravel?

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

    def __read_config(key)
      # try to change configuration only if this is a Laravel application
      # otherwise, raise an error
      raise LaravelNotFoundError unless has_laravel?

      conf = config_file

      # make the required substitution in the configuration file
      text  = File.read conf
      match = text.match(/'#{key}' => (.*),/)
      match ? match[1] : nil
    end
  end
end
