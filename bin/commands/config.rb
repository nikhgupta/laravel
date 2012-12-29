module Laravel
  # This module handles the subcommands used by this gem.
  module Commands
    # Handle config subcommands.
    # This class inherits from thor and can be used to configure
    # various options in the application/config/application.php file.
    class Config < Thor
      # This class-wide option specifies the application directory to use.
      # By default, this is the path to the current directory.
      class_option :app, :type => :string, :aliases => "-a",
        :desc => "use the specified Laravel application instead of current directory"

      # Enable debugger by passing this switch
      class_option :debug, :type => :boolean

      # This task update a configuration setting for an existing application.
      # By default, it updates configuration for the application in the current
      # directory, but this can be overridden by passing +app+ option. It takes
      # a KEY and a VALUE pair and updates the configuration specified by KEY
      # to VALUE.
      #
      # ==== Parameters
      # +key+   :: [STRING] name of a configuration setting found in the
      #            application/config/application.php file. It can be one of the
      #            following values: url, asset_url, index, key, profiler,
      #            encoding, language, or ssl.
      #            Settings: languages and aliases are not supported.
      # +value+ :: [STRING] updated value for this configuration setting.
      #            Configurations that take a boolean value (currently, profiler
      #            and ssl) can take one of the following values to specify truth:
      #            active, on, activated, enable, enabled, true or 1 - everything
      #            else specifies a falsy value.
      desc "update [KEY] [VALUE]", "update the configuration [KEY] to [VALUE]"
      def update(key, value="")
        begin
          config = Laravel::Configuration.new(options[:app])
          config.send("update_#{key}", value)
        rescue StandardError => e
          Laravel::handle_error e, options[:debug]
        end
      end

      # This task reads the current value of a configuration setting for an existing application.
      # By default, it reads configuration for the application in the current
      # directory, but this can be overridden by passing +app+ option.
      #
      # ==== Parameters
      # +key+   :: [STRING] name of a configuration setting found in the
      #            application/config/application.php file. It can be one of the
      #            following values: url, asset_url, index, key, profiler,
      #            encoding, language, or ssl.
      #            Settings: languages and aliases are not supported.
      desc "get [KEY]", "retrieve the configuration [KEY]"
      def get(key)
        begin
          config = Laravel::Configuration.new(options[:app])
          config.send("read_#{key}")
        rescue StandardError => e
          Laravel::handle_error e, options[:debug]
        end
      end

    end
  end
end

