module Laravel
  # This module handles the subcommands used by this gem.
  module Commands
    # Handle config subcommands.
    # This class inherits from thor and can be used to configure
    # various options in the application/config/application.php file.
    class Config < Thor
      class_option :debug, :type => :boolean

      # This class-wide option specifies the application directory to use.
      # By default, this is the path to the current directory.
      class_option :app, :type => :string, :aliases => "-a",
        :desc => "use the specified Laravel application instead of current directory"

      # This task updates the Application Index for an application.
      #
      desc "index [NEW_INDEX]", "modify the Application Index for Laravel application"
      def index(new_index)
        @config = Laravel::Configuration.new(options[:app])
        begin
          @config.update_index new_index
        rescue StandardError => e
          Laravel::handle_error e, options[:debug]
        end
      end

      # This task generates a new key for our application.
      #
      desc "key", "generate a new key for Laravel application"
      def key(value=nil)
        @config = Laravel::Configuration.new(options[:app])
        begin
          @config.update_key
        rescue StandardError => e
          Laravel::handle_error e, options[:debug]
        end
      end

    end
  end
end

