module Laravel

  class InvalidArgumentError < StandardError
    def initialize(message = "Invalid arguments specified!")
      super(message)
    end
  end

  class LaravelNotFoundError < StandardError
    def initialize(message = "Is this a valid Laravel application?")
      super(message)
    end
  end

  class InvalidSourceRepositoryError < StandardError
    def initialize(message = "Source for downloading Laravel repository is corrupt!")
      super(message)
    end
  end

  class LaravelError < StandardError
    def initialize(message = "A general error occurred while processing the command!")
      super(message)
    end
  end

  class RequiredForceMissingError < StandardError
    def initialize(message = "You must pass in --force parameter to force an overwrite!")
      super(message)
    end
  end

  class RequiredLibraryMissingError < StandardError
    def initialize(message = nil)
      message = message ? "#{message} is required! Please, install it."
                        : "One of the required library is missing, e.g. git, curl, etc.!"
      super(message)
    end
  end

  class ExpectationNotMetError < StandardError
    def initialize(message = "Test failed because expectation was not met!")
      super(message)
    end
  end

  class FileNotFoundError < StandardError
    def initialize(message = nil)
      message = message ? "File not found: #{message}" : "Could not find the specified file!"
      super(message)
    end
  end

  # Show an error the user in Red, and exit the script, since this is an error!
  def self.handle_error(error, debug = false)
    shell = Thor::Shell::Color.new
    shell.say_status("!!ERROR!!", error.message, :red)
    if debug
      puts
      puts "--"
      puts error.backtrace
    end
    exit
  end

end
