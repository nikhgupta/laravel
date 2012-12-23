module Laravel
  # This class handles the installation of certain tasks or some bundles, e.g.
  # bob, sentry, etc.  Since, these installation do not follow a definite
  # pattern, we will need to define method that handles a particular
  # installation.
  class Installer < App

    # This method acts as a gateway for the installation methods exposed by
    # this class.  The exposed methods follow a definite naming convention:
    # {type}_{resource}, where {type} can either be 'task' or 'bundle', and
    # {resource} is the name of the thing we are trying to install.
    #
    # For example: calling: task_generator() will install a task in the
    # application/tasks/ folder, where 'do_task_generator' method defines how
    # the particular install wil really be handled.  Please, have a look at the
    # source code of the above example for more information.
    #
    # The 'do_{method}' methods must be defined in this class, which actually
    # handle the installation routine for us. These methods must have 'boolean'
    # as their return value.
    #
    def method_missing(name, *args)
      # know what we are doing
      dissect = name.to_s.split "_"
      type    = dissect[0]
      source  = dissect[1]

      # we MUST have a 'do_{method}' defined!!
      if Installer.method_defined?("do_#{name}".to_sym)

        if method("do_#{name}").call
          say_success "Installed #{type}: #{source.capitalize}"
        else
          say_failed "Could not install #{type}: #{source.capitalize}"
        end
      else
        say_failed "Don't know how to install #{source.capitalize}!"
      end
    end

    # install the particular tasks or bundles by looking the options
    # that the user has provided when running the 'new' task.
    #
    def from_options
      return unless @options

      # read and perform installs from options passed through the command line.
      task_generator if @options[:generator]
    end

    # Install the Laravel Generator by Jeffrey Way.  This creates a file named
    # 'generate.php' in the application/tasks/ folder, which can be invoked as:
    # `php artisan generate` using artisan.
    #
    def do_task_generator
      url  = "https://raw.github.com/JeffreyWay/Laravel-Generator/master/generate.php"
      # download the Laravel Generator using curl as 'generate.php'
      download_resource(tasks_file("generate.php"), url, "curl")
    end
  end
end
