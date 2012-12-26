module Laravel
  # This module handles the subcommands used by this gem.
  module Commands
    # This class is responsible for the various installation tasks
    # e.g. installing the bundles or other goodies.
    class Install < Thor
      class_option :debug, :type => :boolean

      # This option specifies the application directory to use.
      # By default, this is the path to the current directory.
      class_option :app, :type => :string, :aliases => "-a",
        :desc => "use the specified Laravel application instead of current directory"

      # This option specifies whether we want to forcefully install
      # the resource by overwriting already existing files.
      # Virtually, this is the same as reinstalling a certain resource.
      class_option :force, :type => :boolean,
        :desc => "force an installation - same as reinstall"

      # This task downloads the Laravel Generator by Jeffrey Way and creates
      # a file called 'generate.php' in the tasks folder.
      #
      # Once done, we can use `php artisan generate` to get an overview of the
      # different actions this laravel-task can perform.
      #
      desc "generator", "download the Laravel Generator by Jeffrey Way"
      def generator
        @installer = Laravel::Installer.new(options[:app])
        begin
          @installer.task_generator
        rescue StandardError => e
          Laravel::handle_error e, options[:debug]
        end
      end
    end
  end
end
