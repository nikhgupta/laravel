module Laravel

  # A general 'Laravel' error.
  class LaravelError < StandardError
    def initialize(message = "A general error occurred while processing..")
      super(message)
    end
  end

  # Error to be raised when Laravel is expected in a directory, but not found
  class LaravelNotFoundError < StandardError
    def initialize(message = "Is this a valid Laravel application?")
      super(message)
    end
  end

  # Error to be raised when Expectation is not same as Actual result
  # used in Cucumber Tests
  class ExpectationNotMetError < StandardError
    def initialize(message = "Test failed because expectation was not met!")
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
    exit 128
  end

end
