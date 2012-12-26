module Laravel
  # This class handles the configuration aspects of a Laravel based
  # application.  This allows us to read and update settings in
  # ./application/config/application.php Furthermore, it allows us to read and
  # update various options, at one go.
  class Configuration < App

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
      # capture the input from callee
      value = args[0]

      # understand what the callee is requesting..
      dissect = name.to_s.split "_"
      action  = dissect[0]
      setting = dissect[1]

      # lets manipulate the input value if a 'do_{method}' exists
      new_value = method("do_#{name}").call(value) if Configuration.method_defined?("do_#{name}".to_sym)
      # otherwise, use the passed value without any manipulations
      new_value = value if new_value.nil? or new_value.strip.empty?

      # handle the {action} part of the method
      # performs a read/update on the Configuration setting.
      response = case action
                 when "read" then __read_config(setting)
                 when "update" then __update_config(setting, new_value)
                 else raise InvalidArgumentError
                 end

      # let the user know when we set the value to an empty string
      new_value = "__empty_string__" if new_value.nil? or new_value.strip.empty?

      # Let the user know that we have performed an action
      if response and action != "read"
        say_success "#{action.capitalize}d configuration: #{setting} => #{new_value}"
      else
        say_failed "Could not #{action} configuration: #{setting.capitalize}!"
      end
    end

    # update the configuration settings by looking at the options
    # that the user has provided when running the 'new' task.
    #
    def update_from_options
      # don't do anything, unless options were provided
      return unless @options

      # update permissions on storage/ directory (this is the default)
      update_permissions_on_storage if @options[:perms]
      # update Application Index, if provided
      update_index @options[:index] unless @options[:index].nil?
      # generate a new key, if asked for.
      update_key if @options[:key]
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
      make_md5
    end

    private

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
      # default to current working directory if path is not specified
      conf = config_file

      # try to change configuration only if this is a Laravel application
      # otherwise, raise an error
      raise LaravelNotFoundError unless has_laravel?

      # make the required substitution in the configuration file
      text = File.read conf
      text = text.gsub(/'#{key}' => '.*'/, "'#{key}' => '#{new_value}'")
      File.open(conf, "w") {|file| file.puts text}

      # check to ensure we were able to update configuration
      File.readlines(conf).grep(/'#{key}' => '#{new_value}'/).any?
    end

  end
end
