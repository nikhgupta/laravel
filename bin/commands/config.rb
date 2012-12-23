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

      # This task updates the Application Index for an application.
      #
      desc "index [NEW_INDEX]", "modify the Application Index for Laravel application"
      def index(new_index)
        @config = Laravel::Configuration.new(options[:app])
        @config.update_index new_index
      end

      # This task generates a new key for our application.
      #
      desc "key", "generate a new key for Laravel application"
      def key(value=nil)
        @config = Laravel::Configuration.new(options[:app])
        @config.update_key
      end

    end
  end
end

